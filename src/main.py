import logging
import os
import pickle
from functools import partial
from urllib.parse import urlparse as parse_url

import redis
import requests
from bs4 import BeautifulSoup
from hy import HyKeyword
from hy.core.language import comp, is_integer, is_none, name
from hy.core.shadow import hyx_not
from telegram import Bot, ParseMode
from telegram.utils.helpers import escape_markdown

import sources

logging.basicConfig(
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s", level=logging.INFO
)
logger = logging.getLogger(__name__)
escape_markdown_v2 = partial(escape_markdown, version=2)


def get_redis_client():
    if "REDIS_TLS_URL" in os.environ:
        logger.info("Using a secure Redis connection because REDIS_TLS_URL is set")
        connection_string = parse_url(os.environ["REDIS_TLS_URL"])
        _hy_anon_var_1 = redis.Redis(
            host=connection_string.hostname,
            port=connection_string.port,
            password=connection_string.password,
            ssl=True,
            ssl_cert_reqs=None,
        )
    else:
        logger.warning(
            "Not using a secure Redis connection because REDIS_TLS_URL is not set"
        )
        _hy_anon_var_1 = redis.from_url(os.environ["REDIS_URL"])
    return _hy_anon_var_1


def parse_headlines(html_doc):
    def parse_headline(headline):
        if is_none(headline):
            return
            _hy_anon_var_3 = None
        else:
            _hy_anon_var_3 = None
        title = headline.get_text()
        url = headline["href"]
        source = sources.source_from_url(url)
        is_important = False
        is_italic = False
        child_element = headline.findChild()
        if not is_none(child_element):
            child_name = child_element.name.lower()
            if child_name == "font" and child_element["color"].lower() == "red":
                is_important = True
                _hy_anon_var_5 = None
            else:
                if child_name == "i":
                    is_italic = True
                    _hy_anon_var_4 = None
                else:
                    _hy_anon_var_4 = None
                _hy_anon_var_5 = _hy_anon_var_4
            _hy_anon_var_6 = _hy_anon_var_5
        else:
            _hy_anon_var_6 = None
        return {
            HyKeyword("title"): title,
            HyKeyword("url"): url,
            HyKeyword("source"): source,
            HyKeyword("important?"): is_important,
            HyKeyword("italic?"): is_italic,
        }

    soup = BeautifulSoup(html_doc, "html.parser")
    selector = "body > tt > b > tt > b > center"
    headlines_element = soup.select_one(selector)
    parsed = list(
        filter(
            comp(hyx_not, is_none), map(parse_headline, headlines_element.select("a"))
        )
    )
    return parsed


def get_latest_headlines():
    html_doc = requests.get("https://drudgereport.com").content
    headlines = parse_headlines(html_doc)
    latest_headlines_key = "latest-headlines"
    redis_client = get_redis_client()
    old_headlines = redis_client.get(latest_headlines_key)
    if is_none(old_headlines):
        _hy_anon_var_9 = redis_client.set(latest_headlines_key, "")
    else:
        old_headlines = pickle.loads(old_headlines)
        _hy_anon_var_9 = None
    if old_headlines == headlines:
        return None
        _hy_anon_var_10 = None
    else:
        _hy_anon_var_10 = None
    redis_client.set(latest_headlines_key, pickle.dumps(headlines))
    return headlines


def build_message(headlines):
    def build_article(headline):
        title = escape_markdown_v2(headline[HyKeyword("title")])
        url = escape_markdown_v2(headline[HyKeyword("url")], entity_type="text_link")
        source = headline[HyKeyword("source")]
        is_important = headline[HyKeyword("important?")]
        is_italic = headline[HyKeyword("italic?")]
        article = (
            f"[*{title}*]({url})"
            if is_important
            else f"[_{title}_]({url})"
            if is_italic
            else f"[{title}]({url})"
            if True
            else None
        )
        [type, name] = source
        return (
            f"{article} \\({escape_markdown_v2(name)}\\)"
            if type == HyKeyword("named")
            else f"{article} \\(`{escape_markdown_v2(name)}`\\) \\#unnamed"
        )

    if not is_none(headlines):
        message = map(lambda headline: f"\\- {build_article(headline)}", headlines)
        _hy_anon_var_13 = "\n".join(message)
    else:
        _hy_anon_var_13 = None
    return _hy_anon_var_13


if __name__ == "__main__":
    import sys

    def _hy_anon_var_15(*_hyx_GXUffffX2):
        token = os.environ["TOKEN"]
        chat_id = os.environ["CHAT_ID"]
        bot = Bot(token)
        message = build_message(get_latest_headlines())
        return (
            bot.send_message(
                chat_id=chat_id,
                text=message,
                parse_mode=ParseMode.MARKDOWN_V2,
                disable_web_page_preview=True,
            )
            if not is_none(message)
            else None
        )

    _hyx_GXUffffX1 = _hy_anon_var_15(*sys.argv)
    _hy_anon_var_16 = sys.exit(_hyx_GXUffffX1) if is_integer(_hyx_GXUffffX1) else None
else:
    _hy_anon_var_16 = None
