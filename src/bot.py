import json
import logging
import os
import time
from urllib.parse import urlparse as parse_url

import redis
import requests
import rich.traceback
from rich.logging import RichHandler
from telegram import Bot


class DrudgeBot:
    def __init__(self, token: str, chat_id: str) -> None:
        logging.basicConfig(
            format="%(asctime)s - %(message)s",
            level=logging.INFO,
            handlers=[RichHandler()],
        )

        logging.Formatter.converter = time.gmtime

        self._logger = logging.getLogger("DrudgeBot")

        self._logger.info("Starting")

        self._logger.info("Initializing bot")
        self._bot = Bot(token)

        self._chat_id = chat_id

        self._logger.info("Initializing requests session")
        self._sess = requests.Session()

        if "REDIS_TLS_URL" in os.environ:
            self._logger.info("Using a secure Redis connection")

            connection_string = parse_url(os.environ["REDIS_TLS_URL"])

            self._redis = redis.Redis(
                host=connection_string.hostname,
                port=connection_string.port,
                password=connection_string.password,
                ssl=True,
                ssl_cert_reqs=None,
            )
        else:
            self._logger.warning("Not using a secure Redis connection")

            self._redis = redis.from_url(os.environ["REDIS_URL"])

        self._logger.info("Loading sources")

        with open("sources.json") as f:
            sources = json.load(f)
            self._sources = {}

            for name, domains in sources.items():
                if name == "$schema":
                    # This isn't a source. We don't need to skip it, or
                    # do anything else with it, really, but it lets us report
                    # an accurate count later on.
                    continue

                if isinstance(domains, list):
                    for domain in domains:
                        self._logger.debug("%r -> %r", domain, name)

                        self._sources[domain] = name
                else:
                    self._logger.debug("%r -> %r", domains, name)

                    self._sources[domains] = name

        self._logger.info("%d sources loaded", len(self._sources))

    def send_message(self) -> None:
        self._logger.info("Sending message")

        self._bot.send_message(chat_id=self._chat_id, text="Hello World!")

    def close(self) -> None:
        # We use a 'close' method rather than a context manager—which would
        # clearly be the more Pythonic choice—because the latter doesn't play
        # nicely with the rich exception handler.
        self._logger.info("Cleaning up requests session")
        self._sess.close()

        self._logger.info("Cleaning up Redis connection")
        self._redis.close()


def main():
    rich.traceback.install()

    bot = DrudgeBot(os.environ["TOKEN"], os.environ["CHAT_ID"])

    bot.send_message()
    bot.close()


if __name__ == "__main__":
    main()
