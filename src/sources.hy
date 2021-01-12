(import [urllib.parse [urlparse :as parse-url]])

(setv -sources {"www.cbsnews.com" "CBS News"
                "www.wsj.com" "Wall Street Journal"
                "www.dailymail.co.uk" "Daily Mail"
                "www.axios.com" "Axios"
                "www.nbcnews.com" "NBC News"
                "apnews.com" "AP"
                "www.cnbc.com" "CNBC"
                "www.thedailybeast.com" "The Daily Beast"
                "www.cnn.com" "CNN"
                "nypost.com" "New York Post"
                "www.seattletimes.com" "The Seattle Times"
                "www.bloomberg.com" "Bloomberg"
                "www.the-sun.com" "The US Sun"
                "www.mediaite.com" "Mediaite"
                "www.politico.com" "Politico"})

(defn source-from-url [url]
  (setv host-name (. (parse-url url) netloc))
  
  (try
    (, :named (get -sources host-name))
    (except [KeyError]
      (, :unnamed host-name))))
