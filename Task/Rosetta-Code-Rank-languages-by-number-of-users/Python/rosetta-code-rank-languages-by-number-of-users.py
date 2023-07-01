"""Rank languages by number of users. Requires Python >=3.5"""

import requests

# MediaWiki API URL.
URL = "http://rosettacode.org/mw/api.php"

# Query string parameters
PARAMS = {
    "action": "query",
    "format": "json",
    "formatversion": 2,
    "generator": "categorymembers",
    "gcmtitle": "Category:Language users",
    "gcmlimit": 500,
    "prop": "categoryinfo",
}


def fetch_data():
    counts = {}
    continue_ = {"continue": ""}

    # Keep making HTTP requests to the MediaWiki API if more records are
    # available.
    while continue_:
        resp = requests.get(URL, params={**PARAMS, **continue_})
        resp.raise_for_status()

        data = resp.json()

        # Grab the title (language) and size (count) only.
        counts.update(
            {
                p["title"]: p.get("categoryinfo", {}).get("size", 0)
                for p in data["query"]["pages"]
            }
        )

        continue_ = data.get("continue", {})

    return counts


if __name__ == "__main__":
    # Request data from the MediaWiki API.
    counts = fetch_data()

    # Filter out languages that have less than 100 users.
    at_least_100 = [(lang, count) for lang, count in counts.items() if count >= 100]

    # Sort languages by number of users
    top_languages = sorted(at_least_100, key=lambda x: x[1], reverse=True)

    # Pretty print
    for i, lang in enumerate(top_languages):
        print(f"{i+1:<5}{lang[0][9:][:-5]:<20}{lang[1]}")
