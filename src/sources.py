import json
from functools import lru_cache
from urllib.parse import urlparse as parse_url

import requests
from bs4 import BeautifulSoup
from hy import HyKeyword
from hy.core.language import is_none, name


@lru_cache(maxsize=1)
def load_sources():
    _hy_anon_var_2 = None
    with open("sources.json") as f:
        parsed_sources = json.load(f)
        sources = {}
        for [name, domains] in parsed_sources.items():
            if isinstance(domains, str):
                sources[domains] = name
                _hy_anon_var_1 = None
            else:
                for domain in domains:
                    sources[domain] = name
                _hy_anon_var_1 = None
        _hy_anon_var_2 = None
    return sources


def source_from_url(url):
    host_name = parse_url(url).netloc
    if host_name == "www.msn.com":
        host_name = parse_url(get_msn_source(url)).netloc
        _hy_anon_var_4 = None
    else:
        _hy_anon_var_4 = None
    if ".yahoo.com" in host_name:
        host_name = parse_url(get_yahoo_source(url)).netloc
        _hy_anon_var_5 = None
    else:
        _hy_anon_var_5 = None
    if host_name == "www.twitter.com" or host_name == "twitter.com":
        return HyKeyword("unnamed"), format_twitter_url(url)
        _hy_anon_var_6 = None
    else:
        _hy_anon_var_6 = None
    name = load_sources().get(host_name)
    return (
        (HyKeyword("named"), name)
        if not is_none(name)
        else (HyKeyword("unnamed"), host_name)
    )


def get_soup(url):
    html_doc = requests.get(url).content
    return BeautifulSoup(html_doc, "html.parser")


def get_msn_source(url):
    soup = get_soup(url)
    canonical_href = soup.find("link", rel="canonical")["href"]
    return canonical_href


def get_yahoo_source(url):
    soup = get_soup(url)
    meta = json.loads(soup.find("script", type="application/ld+json").string)
    return meta["provider"]["url"]


def format_twitter_url(url):
    path = parse_url(url).path
    path_parts = path.split("/")
    username = path_parts[1]
    return f"twitter.com/{username}"
