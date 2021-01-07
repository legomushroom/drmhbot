(import [urllib.parse [urlparse :as parse-url]])

(setv -sources {"www.cbsnews.com" "CBS News"
                "www.wsj.com" "Wall Street Journal"
                "www.dailymail.co.uk" "Daily Mail"
                "www.axios.com" "Axios"
                "www.nbcnews.com" "NBC News"
                "apnews.com" "AP"})

(defn source-name-from-url [url]
  (setv host-name (. (parse-url url) netloc))
  
  (.get -sources host-name host-name))
