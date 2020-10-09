import logging
import os
import sys

import redis
import requests
from bs4 import BeautifulSoup
from telegram import Bot, ParseMode

logging.basicConfig(
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s", level=logging.INFO
)

logger = logging.getLogger(__name__)


def get_latest_headlines():
    LATEST_HEADLINES_KEY = "latest_headlines"

    html_doc = requests.get("https://drudgereport.com").content
    soup = BeautifulSoup(html_doc, "html.parser")

    headlines_el = soup.select_one("body > tt > b > tt > b > center")
    headlines = []

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

        if headline.parent.name == "i":
            italic = True

        headlines.append(
            {"title": title, "url": url, "important": important, "italic": italic}
        )

    r = redis.from_url(os.environ["REDIS_URL"])

    old_headlines = r.get(LATEST_HEADLINES_KEY)

    if old_headlines == headlines:
        return None

    r.set(LATEST_HEADLINES_KEY, headlines)

    return headlines


def build_message(headlines):
    if headlines is None:
        return None

    # TODO: Handle italic headlines
    message = ""

    for headline in headlines:
        title = headline["title"]
        url = headline["url"]
        important = headline["important"]
        italic = headline["italic"]

        article = f"[{title}]({url})"

        if important:
            article = f"**{article}**"
        elif italic:
            article = f"*{article}*"

        message += f"- {article}\n"

    return message


def main():
    token = os.environ["TOKEN"]
    bot = Bot(token)

    try:
        message = build_message(get_latest_headlines())

        if message is not None:
            bot.send_message(
                chat_id="@DrudgeReportHeadlines",
                text=message,
                parse_mode=ParseMode.MARKDOWN,
                disable_web_page_preview=True,
            )
    except Exception as e:
        sys.exit(e)

    sys.exit(0)


if __name__ == "__main__":
    main()
