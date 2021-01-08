(import [urllib.parse [urlparse :as parse-url]])

(setv -sources {"www.cbsnews.com" "CBS News"
                "www.wsj.com" "Wall Street Journal"
                "www.dailymail.co.uk" "Daily Mail"
                "www.axios.com" "Axios"
                "www.nbcnews.com" "NBC News"
                "apnews.com" "AP"
                "news.yahoo.com" "Yahoo! News"
                "www.cnbc.com" "CNBC"})

(defn source-from-url [url]
  (setv host-name (. (parse-url url) netloc))
  
  (try
    (, :named (get -sources host-name))
    (except [KeyError]
      (, :unnamed host-name))))
