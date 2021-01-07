(import [functools [partial]]
        logging
        os
        pickle)

(import [bs4 [BeautifulSoup]]
        [telegram [Bot ParseMode]]
        [telegram.utils.helpers [escape-markdown]]
        redis
        requests)

(import sources)

(logging.basicConfig :format "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
                     :level logging.INFO)

(setv logger (logging.getLogger __name__))

(setv escape-v2 (partial escape-markdown :version 2))

(defn parse-headlines [html-doc]
  (defn parse-headline [headline]
    (if (none? headline)
      (return))

    (setv title (.get-text headline)
          url (get headline "href")
          important? False
          italic? False)

    (setv child-element (.findChild headline))
    
    (unless (none? child-element)
      (setv child-name (. child-element name))

      (cond
        [(and (= child-name "font") (= (get child-element "color") "red"))
          (setv important? True)]
        [(= child-name "i")
          (setv italic? True)]))
    
      {:title title
       :url url
       :important? important?
       :italic? italic?})

  (setv soup (BeautifulSoup html-doc "html.parser")
        selector "body > tt > b > tt > b > center"
        headlines-element (soup.select-one selector))
  
  (list
    (filter (comp not none?)
      (map (fn [headline] (parse-headline headline)) (headlines-element.select "a")))))

(defn get-latest-headlines []
  (setv html-doc (. (requests.get "https://drudgereport.com") content)
        headlines (parse-headlines html-doc))
  
  (setv latest-headlines-key "latest-headlines"
        redis-client (redis.from-url (get os.environ "REDIS_URL"))
        old-headlines (redis-client.get latest-headlines-key))
  
  (if (none? old-headlines)
    (redis-client.set latest-headlines-key "")
    (setv old-headlines (pickle.loads old-headlines)))

  (if (= old-headlines headlines)
    (return None))
  
  (redis-client.set latest-headlines-key (pickle.dumps headlines))

  headlines)

(defn build-message [headlines]
  (defn build-article [headline]
    (setv title (escape-v2 (get headline :title))
          url (escape-v2 (get headline :url) :entity-type "text_link")
          important? (get headline :important?)
          italic? (get headline :italic?))
    
    (setv article (cond
      [important? f"[*{title}*]({url})"]
      [italic? f"[_{title}_]({url})"]
      [True f"[{title}]({url})"]))
    
    ; TODO: move source name to parse-headlines
    (setv source-name f"`{(escape-v2 (sources.source-name-from-url url))}`")
    
    f"{article} \({source-name}\)")

  (unless (none? headlines)
    (setv message (map (fn [headline] f"\\- {(build-article headline)}") headlines))
    (.join "\n" message)))

(defmain [&rest args]
  (setv token (get os.environ "TOKEN"))
  (setv bot (Bot token))
  
  (setv message (build-message (get-latest-headlines)))
  
  (unless (none? message)
    (bot.send-message :chat-id "@DrudgeReportHeadlines"
                      :text message
                      :parse-mode ParseMode.MARKDOWN_V2
                      :disable-web-page-preview True)))
