import json
import logging
import os
import sys
from typing import List, NoReturn, Optional

import redis
import requests
from bs4 import BeautifulSoup
from telegram import Bot, ParseMode
from telegram.utils.helpers import escape_markdown

from headline import Headline

logging.basicConfig(
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s", level=logging.INFO
)

logger = logging.getLogger(__name__)


def parse_headlines(html_doc: bytes) -> List[Headline]:
    soup = BeautifulSoup(html_doc, "html.parser")

    headlines_el = soup.select_one("body > tt > b > tt > b > center")
    headlines: List[Headline] = []

    for headline in headlines_el.select("a"):
        if headline is None:
            continue

        title = headline.get_text()
        url = headline["href"]

        important = False
        italic = False
        child = headline.findChild()

        if child is not None:
            if child.name == "font" and child["color"] == "red":
                important = True
            elif child.name == "i":
                italic = True

        headlines.append(
            {"title": title, "url": url, "important": important, "italic": italic}
        )

    return headlines


def get_latest_headlines() -> Optional[List[Headline]]:
    LATEST_HEADLINES_KEY = "latest_headlines"

    html_doc = requests.get("https://drudgereport.com").content
    headlines = parse_headlines(html_doc)

    r = redis.from_url(os.environ["REDIS_URL"])

    old_headlines = r.get(LATEST_HEADLINES_KEY)

    if old_headlines is None:
        r.set(LATEST_HEADLINES_KEY, "")
    else:
        old_headlines = json.loads(old_headlines)

    if old_headlines == headlines:
        return None

    r.set(LATEST_HEADLINES_KEY, json.dumps(headlines))

    return headlines


def build_message(headlines: Optional[List[Headline]]) -> Optional[str]:
    if headlines is None:
        return None

    message = ""

    for headline in headlines:
        title = escape_markdown(headline["title"], version=2)
        url = escape_markdown(headline["url"], version=2, entity_type="text_link")
        important = headline["important"]
        italic = headline["italic"]

        article = (
            f"[*{title}*]({url})"
            if important
            else f"[_{title}_]({url})"
            if italic
            else f"[{title}]({url})"
        )

        message += f"\\- {article}\n"

    return message


def main() -> NoReturn:
    token = os.environ["TOKEN"]
    bot = Bot(token)

    try:
        message = build_message(get_latest_headlines())

        if message is not None:
            bot.send_message(
                chat_id="@DrudgeReportHeadlines",
                text=message,
                parse_mode=ParseMode.MARKDOWN_V2,
                disable_web_page_preview=True,
            )
    except Exception as e:
        sys.exit(e)

    sys.exit(0)


if __name__ == "__main__":
    main()
