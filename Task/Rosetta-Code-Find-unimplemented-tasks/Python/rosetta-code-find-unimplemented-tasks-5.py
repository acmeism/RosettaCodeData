import logging
from typing import Iterable
from typing import NamedTuple
from typing import Set

import requests
from requests.adapters import HTTPAdapter
from requests.adapters import Retry

logging.basicConfig(level=logging.DEBUG)

URL = "https://rosettacode.org/w/api.php"

CM_QUERY = {
    "action": "query",
    "generator": "categorymembers",
    "format": "json",
    "formatversion": "2",
    "prop": "info",
    "inprop": "url|touched",
    "gcmlimit": 500,
}


class PageInfo(NamedTuple):
    pageid: int
    ns: int
    title: str
    contentmodel: str
    pagelanguage: str
    pagelanguagehtmlcode: str
    pagelanguagedir: str
    touched: str
    lastrevid: int
    length: int
    fullurl: str
    editurl: str
    canonicalurl: str


def get_session() -> requests.Session:
    """Setup a requests.Session with retries."""
    retry_strategy = Retry(
        total=5,
        status_forcelist=[429, 500, 502, 503, 504],
        allowed_methods=["HEAD", "GET", "OPTIONS"],
    )
    adapter = HTTPAdapter(max_retries=retry_strategy)
    session = requests.Session()
    session.mount("https://", adapter)
    session.mount("http://", adapter)
    return session


def category_members(category: str, url: str = URL) -> Iterable[PageInfo]:
    params = {**CM_QUERY, "gcmtitle": category}
    session = get_session()

    response = session.get(url, params=params)
    response.raise_for_status()
    data = response.json()

    for page in data["query"]["pages"]:
        yield PageInfo(**{k: v for k, v in page.items() if k in PageInfo._fields})

    _continue = data.get("continue", {}).get("gcmcontinue")

    while _continue:
        params["continue"] = data["continue"]["continue"]
        params["gcmcontinue"] = _continue

        response = session.get(url, params=params)
        response.raise_for_status()
        data = response.json()

        for page in data["query"]["pages"]:
            yield PageInfo(**{k: v for k, v in page.items() if k in PageInfo._fields})

        _continue = data.get("continue", {}).get("gcmcontinue")


def lang_tasks(language: str) -> Set[PageInfo]:
    return set(category_members(f"Category:{language}"))


def omitted_tasks(language: str) -> Set[PageInfo]:
    return set(category_members(f"Category:{language}/Omit"))


def unimplemented_tasks(lang_tasks: Set[PageInfo], omitted: Set[PageInfo]) -> Set[str]:
    tasks = set(category_members("Category:Programming Tasks"))
    return tasks.difference(lang_tasks).difference(omitted)


def unimplemented_draft_tasks(
    lang_tasks: Set[PageInfo], omitted: Set[PageInfo]
) -> Set[str]:
    tasks = set(category_members("Category:Draft Programming Tasks"))
    return tasks.difference(lang_tasks).difference(omitted)


def display(title: str, pages: Iterable[PageInfo]) -> None:
    print(title)
    for page in pages:
        print("  ", page.title, page.canonicalurl)
    print("")


if __name__ == "__main__":
    lang = lang_tasks("Python")
    omitted = omitted_tasks("Python")
    display("Programming Tasks", unimplemented_tasks(lang, omitted))
    display("Draft Programming Tasks", unimplemented_draft_tasks(lang, omitted))
    display("Omitted Tasks", omitted)
