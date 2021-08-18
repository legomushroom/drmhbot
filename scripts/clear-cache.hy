#!/usr/bin/env hy

(import os)

(import redis)

(defmain []
    (setv latest-headlines-key "latest-headlines"
          redis-client (redis.from-url (get os.environ "REDIS_URL")))
    
    (redis-client.delete latest-headlines-key))
