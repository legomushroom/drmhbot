import functools
import json
import logging
import os
import time
from dataclasses import dataclass
from typing import Optional
from urllib.parse import ParseResult
from urllib.parse import urlparse as parse_url

import redis
import requests
import rich.traceback
from bs4 import BeautifulSoup
from rich.logging import RichHandler
from telegram import Bot, ParseMode
from telegram.utils.helpers import escape_markdown as original_escape_markdown

escape_markdown = functools.partial(original_escape_markdown, version=2)


@dataclass
class Headline:
    text: str
    url: Optional[str]


@dataclass
class Source:
    name: Optional[str]
    domain: str


class DrudgeBot:
    _PREVIOUS_MESSAGE_KEY = "latest-headlines"

    def __init__(self, token: str, chat_id: str) -> None:
        logging.basicConfig(
            format="%(asctime)s.%(msecs)03d - %(message)s",
            level=logging.INFO,
            datefmt="%Y-%m-%d %H:%M:%S",
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
                if isinstance(domains, list):
                    for domain in domains:
                        self._logger.debug("%r -> %r", domain, name)

                        self._sources[domain] = name
                else:
                    self._logger.debug("%r -> %r", domains, name)

                    self._sources[domains] = name

        # Minus one because we don't want to include the "$schema" key in the count
        self._logger.info("%d sources loaded", len(self._sources) - 1)

    def _get_previous_message(self) -> str:
        self._logger.info("Getting previous message")

        return self._redis.get(DrudgeBot._PREVIOUS_MESSAGE_KEY).decode()

    def _store_message(self, message: str) -> None:
        self._logger.info("Storing message")

        self._redis.set(DrudgeBot._PREVIOUS_MESSAGE_KEY, message)

    def send_message(self) -> None:
        previous_message = self._get_previous_message()
        message = self._build_message(self._get_headlines())

        if message == previous_message:
            self._logger.info("No change, not sending message")
            return

        self._logger.info("Message: %r", message)

        self._bot.send_message(
            chat_id=self._chat_id,
            text=message,
            parse_mode=ParseMode.MARKDOWN_V2,
            disable_web_page_preview=True,
        )

        self._store_message(message)

    def _get_headlines(self) -> list[Headline]:
        self._logger.info("Getting headlines")

        homepage = self._sess.get("https://www.drudgereport.com/")
        soup = BeautifulSoup(homepage.content, "html.parser")

        headline_els = soup.select("tt > b > tt > b > center a")
        headlines = []

        for el in headline_els:
            text = el.text
            url = el["href"]

            headline = Headline(text, url)

            self._logger.debug("Adding %r to headlines", headline)

            headlines.append(headline)

            # TODO: Handle italic, important and italic-important (important-italic?)
            # headlines

        return headlines

    def _get_source(self, url: str) -> Source:
        self._logger.debug("Getting source for %r", url)

        parsed_url = parse_url(url)
        domain = parsed_url.netloc

        if ".twitter.com" in domain:
            return self._get_twitter_source(parsed_url)

        if ".yahoo.com" in domain:
            source = self._get_yahoo_source(url)

            return self._get_source(source)

        if ".msn.com" in domain:
            source = self._get_msn_source(url)

            return self._get_source(source)

        name = self._sources.get(domain)

        return Source(name, domain)

    def _get_twitter_source(self, url: ParseResult) -> Source:
        self._logger.debug("Getting Twitter source for %r", url)

        parts = url.path.split("/")

        self._logger.debug("Twitter path parts: %r", parts)

        return Source(parts[1], "twitter.com")

    def _get_soup(self, url: str) -> BeautifulSoup:
        self._logger.debug("Getting soup for %r", url)

        response = self._sess.get(url)

        return BeautifulSoup(response.content, "html.parser")

    def _get_yahoo_source(self, url: str) -> str:
        soup = self._get_soup(url)
        meta = json.loads(soup.find("script", type="application/ld+json").text)

        return meta["provider"]["url"]

    def _get_msn_source(self, url: str) -> str:
        soup = self._get_soup(url)
        canonical_href = soup.find("link", rel="canonical")["href"]

        return canonical_href

    def _build_message(self, headlines: list[Headline]) -> str:
        self._logger.info("Building message")

        articles = []

        for headline in headlines:
            if headline.url is None:
                articles.append(f"- {headline.text}")
            else:
                source = self._get_source(headline.url)

                text = f"\- [{escape_markdown(headline.text)}]({escape_markdown(headline.url, entity_type='text_link')})"

                if source.name is not None:
                    text += f" \({escape_markdown(source.name)}\)"
                else:
                    if source.domain == "twitter.com":
                        text += f" \(`@{escape_markdown(source.name)}`\)"
                    else:
                        text += f" \(`{escape_markdown(source.domain)}`\) \#unnamed"

                articles.append(text)

        self._logger.debug("Message before joining: %r", articles)

        return "\n".join(articles)

    def cleanup(self) -> None:
        # We use a 'cleanup' method rather than a context manager because the latter
        # doesn't play nicely with the rich exception handler.

        self._logger.info("Cleaning up requests session")
        self._sess.close()

        self._logger.info("Cleaning up Redis connection")
        self._redis.close()


def main():
    rich.traceback.install()

    bot = DrudgeBot(os.environ["TOKEN"], os.environ["CHAT_ID"])

    bot.send_message()
    bot.cleanup()


if __name__ == "__main__":
    main()
