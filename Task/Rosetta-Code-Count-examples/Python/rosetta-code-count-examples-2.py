"""Count Rosetta Code tasks implementations using the Semantic MediaWiki API.
Works with Python >= 3.7."""
import json
import logging

from dataclasses import dataclass
from dataclasses import field

from datetime import datetime

from typing import Any
from typing import Dict
from typing import List
from typing import Optional
from typing import Set
from typing import Tuple

import requests
from requests.adapters import HTTPAdapter
from requests.adapters import Retry

logging.basicConfig(level=logging.WARN)

# See https://www.semantic-mediawiki.org/wiki/Help:API:ask
_SM_ASK: Dict[str, str] = {
    "action": "ask",
    "format": "json",
    "formatversion": "2",
    "api_version": "3",
}

_SM_ASK_REQUEST_BLOCK_SIZE = 500


@dataclass(frozen=True)
class Page:
    # fulltext is the page's title, not the page content.
    fulltext: str
    fullurl: str
    namespace: int
    exists: str
    displaytitle: str


@dataclass(frozen=True, eq=False)
class Lang(Page):
    def __eq__(self, other: object) -> bool:
        if isinstance(other, Lang):
            return self.fullurl == other.fullurl
        elif isinstance(other, str):
            return self.fullurl == other
        return False

    def __hash__(self) -> int:
        return hash(self.fullurl)

    def unimplemented(self, tasks: Set["Task"]) -> Set["Task"]:
        return {task for task in tasks if self.fullurl not in task.exclude}

    def omitted_from(self, tasks: Set["Task"]) -> Set["Task"]:
        return {task for task in tasks if self.fullurl in task.omitted_from}


@dataclass(frozen=True)
class Task(Page):
    title: str
    implemented_in: Set[Lang] = field(repr=False, compare=False)
    omitted_from: Set[Lang] = field(repr=False, compare=False)
    exclude: Set[Lang] = field(repr=False, compare=False)

    def not_implemented_in(self, langs: Set[Lang]) -> Set[Lang]:
        return langs.difference(self.exclude)


@dataclass
class TaskResponseBlock:
    tasks: List[Task]
    continue_offset: Optional[int] = None


@dataclass
class LanguageResponseBlock:
    langs: List[Lang]
    continue_offset: Optional[int] = None


def sm_ask_category(
    session: requests.Session,
    url: str,
    category: str,
    limit: int,
    offset: int,
    known_langs: Set[Lang],
) -> TaskResponseBlock:
    query_params = {
        **_SM_ASK,
        "query": (
            f"[[Category:{category}]]"
            "|?Implemented in language"
            "|?Omitted from language"
            f"|limit={limit}"
            f"|offset={offset}"
        ),
    }

    # Display some progress
    log(f"ask [[Category:{category}]] offset={offset}")

    response = session.get(url, params=query_params)
    response.raise_for_status()
    data = response.json()
    handle_warnings_and_errors(data)
    return _transform_implemented_in_response_data(data, known_langs)


def sm_ask_tasks(
    session: requests.Session,
    url: str,
    limit: int,
    offset: int,
    known_langs: Set[Lang],
):
    return sm_ask_category(
        session, url, "Programming Tasks", limit, offset, known_langs
    )


def sm_ask_drafts(
    session: requests.Session,
    url: str,
    limit: int,
    offset: int,
    known_langs: Set[Lang],
):
    return sm_ask_category(
        session, url, "Draft Programming Tasks", limit, offset, known_langs
    )


def sm_ask_languages(
    session: requests.Session,
    url: str,
    limit: int,
    offset: int,
) -> LanguageResponseBlock:
    query_params = {
        **_SM_ASK,
        "query": (
            "[[Is language::+]]"
            "|?Implemented in language"
            "|?Omitted from language"
            f"|limit={limit}"
            f"|offset={offset}"
        ),
    }

    # Display some progress
    log(f"ask [[Is language::+]] offset={offset}")

    response = session.get(url, params=query_params)
    response.raise_for_status()
    data = response.json()
    handle_warnings_and_errors(data)
    return _transform_language_response_data(data)


def sm_ask_all_tasks(
    session: requests.Session, url: str, known_langs: Set[Lang]
) -> List[Task]:
    block = sm_ask_tasks(
        session,
        url,
        limit=_SM_ASK_REQUEST_BLOCK_SIZE,
        offset=0,
        known_langs=known_langs,
    )
    tasks = block.tasks

    while block.continue_offset:
        block = sm_ask_tasks(
            session,
            url,
            limit=_SM_ASK_REQUEST_BLOCK_SIZE,
            offset=block.continue_offset,
            known_langs=known_langs,
        )
        tasks.extend(block.tasks)

    return tasks


def sm_ask_all_drafts(
    session: requests.Session, url: str, known_langs: Set[Lang]
) -> List[Task]:
    block = sm_ask_drafts(
        session,
        url,
        limit=_SM_ASK_REQUEST_BLOCK_SIZE,
        offset=0,
        known_langs=known_langs,
    )
    tasks = block.tasks

    while block.continue_offset:
        block = sm_ask_drafts(
            session,
            url,
            limit=_SM_ASK_REQUEST_BLOCK_SIZE,
            offset=block.continue_offset,
            known_langs=known_langs,
        )
        tasks.extend(block.tasks)

    return tasks


def sm_ask_all_languages(session: requests.Session, url: str) -> List[Lang]:
    block = sm_ask_languages(
        session,
        url,
        limit=_SM_ASK_REQUEST_BLOCK_SIZE,
        offset=0,
    )
    langs = block.langs

    while block.continue_offset:
        block = sm_ask_languages(
            session,
            url,
            limit=_SM_ASK_REQUEST_BLOCK_SIZE,
            offset=block.continue_offset,
        )
        langs.extend(block.langs)

    return langs


def _transform_implemented_in_response_data(
    data: Any, known_langs: Set[Lang]
) -> TaskResponseBlock:
    tasks: List[Task] = []
    for result in data["query"]["results"]:
        for task_title, task_page in result.items():
            # We're excluding implementations that don't have a corresponding
            # category page with an "Is Language" property.
            implemented_in = {
                Lang(**lang)
                for lang in task_page["printouts"]["Implemented in language"]
            }.intersection(known_langs)

            omitted_from = (
                {
                    Lang(**lang)
                    for lang in task_page["printouts"]["Omitted from language"]
                }
                .intersection(known_langs)
                .difference(implemented_in)
            )

            tasks.append(
                Task(
                    title=task_title,
                    implemented_in=implemented_in,
                    omitted_from=omitted_from,
                    fulltext=task_page["fulltext"],
                    fullurl=task_page["fullurl"],
                    namespace=task_page["namespace"],
                    exists=task_page["exists"],
                    displaytitle=task_page["displaytitle"],
                    exclude=implemented_in.union(omitted_from),
                )
            )

    return TaskResponseBlock(
        tasks=tasks, continue_offset=data.get("query-continue-offset", None)
    )


def _transform_language_response_data(data: Any) -> LanguageResponseBlock:
    langs: List[Lang] = []
    for result in data["query"]["results"]:
        for _, task_page in result.items():
            langs.append(
                Lang(
                    fulltext=task_page["fulltext"],
                    fullurl=task_page["fullurl"],
                    namespace=task_page["namespace"],
                    exists=task_page["exists"],
                    displaytitle=task_page["displaytitle"],
                )
            )

    return LanguageResponseBlock(
        langs=langs, continue_offset=data.get("query-continue-offset", None)
    )


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


def log(msg: str) -> None:
    print(f"{datetime.now().isoformat(' ', 'seconds')}: {msg}")


def handle_warnings_and_errors(data: Any) -> None:
    if data.get("errors"):
        for error in data["errors"]:
            logging.error(json.dumps(error))
    # legacy format
    if data.get("error"):
        logging.error(json.dumps(data["error"]))
    if data.get("warnings"):
        for warning in data["warnings"]:
            logging.warning(json.dumps(warning))


def count_examples(url: str, n: int = 30) -> None:
    """Print a table to stdout containing implementation counts for the first
    `n` tasks, sorted by number implementations (most to least)."""
    session = get_session()
    langs = set(sm_ask_all_languages(session, url))
    tasks = sm_ask_all_tasks(session, url, langs)
    drafts = sm_ask_all_drafts(session, url, langs)
    all_tasks = [*tasks, *drafts]

    # Map of task to (implemented in, not implemented in, omitted from)
    counts: Dict[Task, Tuple[int, int, int]] = {}

    # Running total of examples for all tasks. Where a language has multiple examples
    # for a single tasks, we only count one example.
    total: int = 0

    for task in all_tasks:
        total += len(task.implemented_in)
        counts[task] = (
            len(task.implemented_in),
            len(task.not_implemented_in(langs)),
            len(task.omitted_from),
        )

    # Pretty print
    top = sorted(counts.items(), key=lambda it: it[1][0], reverse=True)[:n]
    pad = max([len(task.fulltext) for task, _ in top])

    print("\nKnown languages:", len(langs))
    print("Total tasks:", len(all_tasks))
    print("Total examples:", total)
    print(f"{'Task':>{pad}} | Implemented In | Not Implemented In | Omitted From")
    print("-" * (pad + 1), "+", "-" * 16, "+", "-" * 20, "+", "-" * 13, sep="")

    for task, _counts in top:
        implemented_in, not_implemented_in, omitted_from = _counts
        print(
            f"{task.fulltext:>{pad}} |"
            f"{implemented_in:>15} |"
            f"{not_implemented_in:>19} |"
            f"{omitted_from:>13}"
        )


if __name__ == "__main__":
    import argparse

    URL = "https://rosettacode.org/w/api.php"
    parser = argparse.ArgumentParser(description="Count tasks on Rosetta Code.")

    parser.add_argument(
        "--rows",
        "-n",
        type=int,
        default=30,
        dest="n",
        help="number of rows to display in the output table (default: 30)",
    )

    parser.add_argument(
        "--url",
        default=URL,
        help=f"target MediaWiki URL (default: {URL})",
    )

    args = parser.parse_args()
    count_examples(args.url, args.n)
