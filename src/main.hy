(import json)
(import logging)
(import os)
(import sys)
(import [functools [partial]])

(import redis)
(import requests)
(import [bs4 [BeautifulSoup]])
(import [telegram [Bot ParseMode]])
(import [telegram.utils.helpers [escape_markdown]])

(logging.basicConfig
  :format "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
  :level logging.INFO)

(setv logger (logging.getLogger __name__))

; TODO: replace with macro
(setv escape-v2 (partial escape_markdown :version 2))
