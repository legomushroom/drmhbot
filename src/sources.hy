(import os
        [urllib.parse [urlparse :as parse-url]])

(defn source-from-url [conn url]
  (setv host-name (. (parse-url url) netloc))

  (if (or (= host-name "www.twitter.com") (= host-name "twitter.com"))
    (return (, :unnamed (parse-twitter-url url))))

  (setv result "")

  (with [conn]
    (with [curs (conn.cursor)]
      (curs.execute "SELECT name FROM sources WHERE hostname = %s" (, host-name))
      (setv result (curs.fetchone))))
  
  (if (not (none? result))
    (, :named (get result 0))
    (, :unnamed host-name)))

(defn parse-twitter-url [url]
  (setv path (. (parse-url url) path)
        path-parts (.split path "/")
        username (get path-parts 1))
  
  f"twitter.com/{username}")
