(import json)
(import logging)
(import os)
(import [functools [partial]])

(import redis)
(import requests)
(import [bs4 [BeautifulSoup]])
(import [telegram [Bot ParseMode]])
(import [telegram.utils.helpers [escape_markdown]])

(logging.basicConfig
  :format "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
  :level logging.INFO)

(setv logger (logging.getLogger __name__))

; TODO: replace with macro
(setv escape-v2 (partial escape_markdown :version 2))

(defn parse-headlines [html-doc]
  (setv soup (BeautifulSoup html-doc "html.parser"))
  (setv selector "body > tt > b > tt > b > center")
  (setv headlines-element (soup.select-one selector))
  (setv headlines [])
  
  ; TODO: rewrite using map
  (for [headline headlines]
    (if (none? headline)
      (continue))
      
    (setv title (.get-text headline))
    (setv url (get headline "href"))
    (setv important? False)
    (setv italic? False)
    
    (if (not (none? child))
      (cond
        [(and
            (= (.name child) "font")
            (= (get child "color") "red"))
          (setv important? True)]
        [(= (.name child) "i")
          (setv italic? True)]))

    (.append headlines {:title title
                        :url url
                        :important? important?
                        :italic? italic?}))

    headlines)

(defn get-latest-headlines []
  (setv latest-headlines-key "latest_headlines")
  (setv html-doc (py "requests.get('https://drudgereport.com').content"))
  (setv headlines (parse-headlines html-doc))
  (setv redis-client (redis.from-url (get os.environ "REDIS_URL")))
  (setv old-headlines (redis-client.get latest-headlines-key))
  
  (if (none? old_headlines)
    (redis-client.set latest-headlines-key "")
    (setv old-headlines (json.loads old-headlines)))

  (if (= old-headlines headlines)
    (return None))
  
  (redis-client.set latest-headlines-key (json.dumps headlines))

  headlines)

(defn build-article [headline]
  (setv title (escape-v2 (get headline :title)))
  (setv url (escape_v2 (get headline :url) :entity_type "text_link"))
  (setv important? (get headline :important?))
  (setv italic? (get headline :italic?))
  
  (cond
    [important? f"[*{title}*]({url})"]
    [italic? f"[_{title}_]({url})"]
    [True f"[{title}]({url})"]))

(defn build-message [headlines]
  (if (none? headlines)
    (return None))
  
  (setv message (map (fn [headline] f"\\- {(build-article headline)}") headlines))
  
  (.join "\n" message))

(defn main []
  (setv token (get os.environ "TOKEN"))
  (setv bot (Bot token))
  
  (setv message (build-message (get-latest-headlines)))
  
  (if (not (none? message))
    (bot.send-message
      :chat-id "@DrudgeReportHeadlines"
      :text message
      :parse-mode ParseMode.MARKDOWN_V2
      :disable-web-page-preview True)))

(if (= __name__ "__main__")
  (main))
