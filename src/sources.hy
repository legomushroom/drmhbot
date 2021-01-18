(import json
        [urllib.parse [urlparse :as parse-url]])

(import [bs4 [BeautifulSoup]]
        requests)

(defn source-from-url [conn url]
  (setv host-name (. (parse-url url) netloc))

  (if (= host-name "www.msn.com")
    (setv host-name (. (parse-url (get-msn-source url)) netloc)))
  
  (if (= host-name "news.yahoo.com")
    (setv host-name (. (parse-url (get-yahoo-source url)) netloc))))

  (if (or (= host-name "www.twitter.com") (= host-name "twitter.com"))
    (return (, :unnamed (format-twitter-url url))))

  (setv result "")

  (with [conn]
    (with [curs (conn.cursor)]
      (curs.execute "SELECT name FROM sources WHERE hostname = %s" (, host-name))
      (setv result (curs.fetchone))))
  
  (if (not (none? result))
    (, :named (get result 0))
    (, :unnamed host-name)))

(defn get-soup [url]
  (setv html-doc (. (requests.get url) content))
  
  (BeautifulSoup html-doc "html.parser"))

(defn get-msn-source [url]
  (setv soup (get-soup url)
        canonical-href (get (soup.find "link" :rel "canonical") "href"))
  
  canonical-href)

(defn get-yahoo-source [url]
  (setv soup (get-soup url)
        meta (json.loads (. (soup.find "script" :type "application/ld+json") string)))
  
  (get meta "provider" "url"))

(defn format-twitter-url [url]
  (setv path (. (parse-url url) path)
        path-parts (.split path "/")
        username (get path-parts 1))
  
  f"twitter.com/{username}")
