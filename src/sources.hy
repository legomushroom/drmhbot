(import [urllib.parse [urlparse :as parse-url]])

(import [bs4 [BeautifulSoup]]
        requests)

(defn source-from-url [conn url]
  (setv host-name (. (parse-url url) netloc))

  (if (= host-name "www.msn.com")
    (setv host-name (get-msn-source url)))

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

(defn get-msn-source [url]
  (setv html-doc (. (requests.get url) content)
        soup (BeautifulSoup html-doc "html.parser")
        canonical-href (get (soup.find "link" :rel "canonical") "href"))
  
  canonical-href)

(defn format-twitter-url [url]
  (setv path (. (parse-url url) path)
        path-parts (.split path "/")
        username (get path-parts 1))
  
  f"twitter.com/{username}")
