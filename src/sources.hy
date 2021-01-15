(import os
        [urllib.parse [urlparse :as parse-url]])

(import psycopg2)

(defn source-from-url [url]
  (setv host-name (. (parse-url url) netloc))

  (if (or (= host-name "www.twitter.com") (= host-name "twitter.com"))
    (return (parse-twitter-url url)))

  (setv result "")

  (setv conn (psycopg2.connect (get os.environ "DATABASE_URL")))

  ; TODO: Find out if this is too slow.
  (with [conn]
    (with [curs (conn.cursor)]
      (curs.execute "SELECT name FROM sources WHERE hostname = %s" (, host-name))
      (setv result (curs.fetchone))))
  
  (conn.close)
  
  (if (not (none? result))
    (, :named (get result 0))
    (, :unnamed host-name)))

(defn parse-twitter-url [url]
  (setv path (. (parse-url url) path)
        path-parts (.split path "/")
        username (get path-parts 1))
  
  f"twitter.com/{username}")
