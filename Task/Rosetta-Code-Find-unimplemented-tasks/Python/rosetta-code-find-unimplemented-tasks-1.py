"""
Given the name of a language on Rosetta Code,
finds all tasks which are not implemented in that language.
"""
from operator import attrgetter
from typing import Iterator

import mwclient

URL = 'www.rosettacode.org'
API_PATH = '/mw/'


def unimplemented_tasks(language: str,
                        *,
                        url: str,
                        api_path: str) -> Iterator[str]:
    """Yields all unimplemented tasks for a specified language"""
    site = mwclient.Site(url, path=api_path)
    all_tasks = site.categories['Programming Tasks']
    language_tasks = site.categories[language]
    name = attrgetter('name')
    all_tasks_names = map(name, all_tasks)
    language_tasks_names = set(map(name, language_tasks))
    for task in all_tasks_names:
        if task not in language_tasks_names:
            yield task


if __name__ == '__main__':
    tasks = unimplemented_tasks('Python', url=URL, api_path=API_PATH)
    print(*tasks, sep='\n')
