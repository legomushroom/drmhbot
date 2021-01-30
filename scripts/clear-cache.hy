(import os)

(import redis)

(defmain []
    (setv latest-headlines-key "latest-headlines"
          redis-client (redis.from-url (get os.environ "REDIS_URL"))
    
    (redis-client.del latest-headlines-key))
