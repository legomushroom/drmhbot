(import [functools [lru-cache]]
        json
        [urllib.parse [urlparse :as parse-url]])

(import [bs4 [BeautifulSoup]]
        requests
        yaml)

#@((lru-cache :maxsize 1)
  (defn load-sources []
    (with [f (open "sources.yml")]
      (setv parsed-sources (yaml.safe-load (.read f))
            sources {})
      
      (for [[domain, name] (.items parsed-sources)]
        (assoc sources domain name)))
  
    sources))

(defn source-from-url [url]
  (setv host-name (. (parse-url url) netloc))

  (if (= host-name "www.msn.com")
    (setv host-name (. (parse-url (get-msn-source url)) netloc)))
  
  (if (yahoo? host-name)
    (setv host-name (. (parse-url (get-yahoo-source url)) netloc)))

  (if (or (= host-name "www.twitter.com") (= host-name "twitter.com"))
    (return (, :unnamed (format-twitter-url url))))

  (setv name (.get (load-sources) host-name))
  
  (if (not (none? name))
    (, :named name)
    (, :unnamed host-name)))

(defn get-soup [url]
  (setv html-doc (. (requests.get url) content))
  
  (BeautifulSoup html-doc "html.parser"))

(defn get-msn-source [url]
  (setv soup (get-soup url)
        canonical-href (get (soup.find "link" :rel "canonical") "href"))
  
  canonical-href)

(defn yahoo? [host-name]
  (in ".yahoo.com" host-name))

(defn get-yahoo-source [url]
  (setv soup (get-soup url)
        meta (json.loads (. (soup.find "script" :type "application/ld+json") string)))
  
  (get meta "provider" "url"))

(defn format-twitter-url [url]
  (setv path (. (parse-url url) path)
        path-parts (.split path "/")
        username (get path-parts 1))
  
  f"twitter.com/{username}")
