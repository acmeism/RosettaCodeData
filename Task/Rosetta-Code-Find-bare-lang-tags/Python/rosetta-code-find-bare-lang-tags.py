"""Count bare `lang` tags in wiki markup. Requires Python >=3.6.

Uses the Python standard library `urllib` to make MediaWiki API requests.
"""

from __future__ import annotations

import functools
import gzip
import json
import logging
import platform
import re

from collections import Counter
from collections import defaultdict

from typing import Any
from typing import Iterator
from typing import Iterable
from typing import List
from typing import Mapping
from typing import NamedTuple
from typing import Optional
from typing import Tuple

from urllib.parse import urlencode
from urllib.parse import urlunparse
from urllib.parse import quote_plus

import urllib.error
import urllib.request

logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)


# Parse wiki markup with these regular expression patterns. Any headings and
# `lang` tags found inside `nowiki`, `pre` or other `lang` tags (bare or not)
# should not count as "bare".
#
# NOTE: The order of these patterns is significant.
RE_SPEC = [
    ("NOWIKI", r"<\s*nowiki\s*>.*?</\s*nowiki\s*>"),
    ("PRE", r"<\s*pre\s*>.*?</\s*pre\s*>"),
    ("LANG", r"<\s*lang\s+.+?>.*?</\s*lang\s*>"),
    ("HEAD", r"==\{\{\s*header\s*\|\s*(?P<header>.+?)\s*}}=="),
    ("BARE", r"<\s*lang\s*>.*?</\s*lang\s*>"),
]

RE_BARE_LANG = re.compile(
    "|".join(rf"(?P<{name}>{pattern})" for name, pattern in RE_SPEC),
    re.DOTALL | re.IGNORECASE,
)

# Some wiki headings look like this "=={{header|Some}} / {{header|Other}}==".
# We'll use this regular expression to strip out the markup.
RE_MULTI_HEADER = re.compile(r"(}|(\{\{\s*header\s*\|\s*))", re.IGNORECASE)


def find_bare_lang_section_headers(wiki_text: str) -> Iterator[str]:
    """Generate a sequence of wiki section headings that contain bare
    'lang' tags.

    If there are multiple bare lang tags in a section, that section
    heading will appear multiple times in the sequence.
    """
    current_heading = "no language"

    for match in RE_BARE_LANG.finditer(wiki_text):
        kind = match.lastgroup

        if kind == "HEAD":
            current_heading = RE_MULTI_HEADER.sub("", match.group("header"))
        elif kind == "BARE":
            yield current_heading


class Error(Exception):
    """Exception raised when we get an unexpected response from the MediaWiki API."""


class TagCounter:
    """Count bare `lang` tags in wiki markup. Group them by heading and
    remember what page they're in."""

    def __init__(self):
        self.counter = Counter()
        self.pages = defaultdict(set)
        self.total = 0

    def __len__(self):
        return len(self.counter)

    @classmethod
    def from_section_headers(
        cls, page_title: str, section_headers: Iterable[str]
    ) -> TagCounter:
        """Return a new `TagCounter` initialized with the given section
        headings."""
        counter = cls()

        for heading in section_headers:
            counter.add(page_title, heading)

        return counter

    @classmethod
    def from_wiki_text(cls, page_title: str, wiki_text: str) -> TagCounter:
        """Return a new `TagCounter` initialized with bare lang tags from the
        given wiki text."""
        return cls.from_section_headers(
            page_title,
            find_bare_lang_section_headers(wiki_text),
        )

    def add(self, page_title: str, section_heading: str):
        """Increment the counter by one for the given section heading an
        page."""
        self.counter[section_heading] += 1
        self.pages[section_heading].add(page_title)
        self.total += 1

    def update(self, other):
        """Union this counter with `other`, another counter."""
        assert isinstance(other, TagCounter)

        self.counter.update(other.counter)

        for section_heading, pages in other.pages.items():
            self.pages[section_heading].update(pages)

        self.total += other.total

    def most_common(self, n=None) -> str:
        """Return a formatted string of the most common wiki sections to have
        bare lang tags."""
        buf = [f"{sum(self.counter.values())} bare lang tags.\n"]

        for section_heading, count in self.counter.most_common(n=n):
            pages = list(self.pages[section_heading])
            buf.append(f"{count} in {section_heading} {pages}")

        return "\n".join(buf)


def quote_underscore(string, safe="", encoding=None, errors=None):
    """Like urllib.parse.quote but replaces spaces with underscores."""
    string = quote_plus(string, safe, encoding, errors)
    return string.replace("+", "_")


class URL(NamedTuple):
    """A `urllib.parse.urlunparse` compatible Tuple with some helper methods.
    We'll use this to build and pass around our MediaWiki API URLs.
    """

    scheme: str
    netloc: str
    path: str
    params: str
    query: str
    fragment: str

    def __str__(self):
        return urlunparse(self)

    def with_query(self, query: Mapping[str, Any]) -> URL:
        query_string = urlencode(query, safe=":", quote_via=quote_underscore)
        return self._replace(query=query_string)


API_BASE_URL = URL(
    scheme="http",
    netloc="rosettacode.org",
    path="/mw/api.php",
    params="",
    query="",
    fragment="",
)

UGLY_RAW_URL = URL(
    scheme="http",
    netloc="rosettacode.org",
    path="/mw/index.php",
    params="",
    query="",
    fragment="",
)

# NOTE: Cloudflare was blocking requests with the default user agent.
DEFAULT_HEADERS = {
    "User-agent": f"python/{platform.python_version()}",
    "Accept-encoding": "gzip, deflate",
    "Accept": "*/*",
    "Connection": "keep-alive",
}


class Response(NamedTuple):
    headers: Mapping[str, str]
    body: bytes


def get(url: URL, headers=DEFAULT_HEADERS) -> Response:
    """Make an HTTP GET request to the given URL."""
    logger.debug(f"GET {url}")
    request = urllib.request.Request(str(url), headers=headers)

    try:
        with urllib.request.urlopen(request) as response:
            return Response(
                headers=dict(response.getheaders()),
                body=response.read(),
            )
    except urllib.error.HTTPError as e:
        logging.debug(e.code)
        logging.debug(gzip.decompress(e.read()))
        raise


def raise_for_header(headers: Mapping[str, str], header: str, expect: str):
    got = headers.get(header)
    if got != expect:
        raise Error(f"expected '{expect}', got '{got}'")


raise_for_content_type = functools.partial(raise_for_header, header="Content-Type")


class CMContinue(NamedTuple):
    continue_: str
    cmcontinue: str


Pages = Tuple[List[str], Optional[CMContinue]]


def get_wiki_page_titles(chunk_size: int = 500, continue_: CMContinue = None) -> Pages:
    """Return a list of wiki page titles and any continuation information."""
    query = {
        "action": "query",
        "list": "categorymembers",
        "cmtitle": "Category:Programming_Tasks",
        "cmlimit": chunk_size,
        "format": "json",
        "continue": "",
    }

    if continue_:
        query["continue"] = continue_.continue_
        query["cmcontinue"] = continue_.cmcontinue

    response = get(API_BASE_URL.with_query(query))

    # Fail early if the response is not what we are expecting.
    raise_for_content_type(response.headers, expect="application/json; charset=utf-8")
    raise_for_header(response.headers, "Content-Encoding", "gzip")

    data = json.loads(gzip.decompress(response.body))
    page_titles = [p["title"] for p in data["query"]["categorymembers"]]

    if data.get("continue", {}).get("cmcontinue"):
        _continue = CMContinue(
            data["continue"]["continue"],
            data["continue"]["cmcontinue"],
        )
    else:
        _continue = None

    return (page_titles, _continue)


def get_wiki_page_markup(page_title: str) -> str:
    """Return raw MediaWiki markup from the page `page_title`."""
    query = {"action": "raw", "title": page_title}
    response = get(UGLY_RAW_URL.with_query(query))

    # Fail early if the response is not what we are expecting.
    raise_for_content_type(response.headers, expect="text/x-wiki; charset=UTF-8")

    return response.body.decode()


def example(limit=30):
    # Get the first chunk of wiki page titles from the MediaWiki API
    page_titles, continue_ = get_wiki_page_titles()

    # Get more chunks if there are any.
    while continue_ is not None:
        more_page_titles, continue_ = get_wiki_page_titles(continue_=continue_)
        page_titles.extend(more_page_titles)

    # Aggregate counts from all pages.
    counter = TagCounter()

    for i, page_title in enumerate(page_titles):
        if i > limit:
            break

        # Read and parse raw wiki page markup.
        wiki_text = get_wiki_page_markup(page_title)
        counts = TagCounter.from_wiki_text(page_title, wiki_text)
        counter.update(counts)

    # Dump the results to stdout.
    print(counter.most_common())


if __name__ == "__main__":
    logging.basicConfig(format="%(asctime)s %(message)s", level=logging.DEBUG)
    example()
