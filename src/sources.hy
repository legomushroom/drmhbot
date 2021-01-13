(import os
        [urllib.parse [urlparse :as parse-url]])

(import psycopg2)

(defn source-from-url [url]
  (setv host-name (. (parse-url url) netloc))

  (setv result "")

  (setv conn (psycopg2.connect (get os.environ "DATABASE_URL")))

  ; TODO: Find out if this is too slow.
  (with [conn]
    (with [curs (conn.cursor)]
      (print host-name)
      (curs.execute "SELECT name FROM sources WHERE hostname = %s" (, host-name))

      (setv result (curs.fetchone))))
  
  (conn.close)
  
  (if (not (none? result))
    (, :named result)
    (, :unnamed host-name)))
