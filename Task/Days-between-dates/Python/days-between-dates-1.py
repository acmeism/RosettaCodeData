"""Days between dates. Requires Python >= 3.9.

https://rosettacode.org/wiki/Days_between_dates#Python
"""


def days(year: int, month: int, day: int) -> int:
    """Return a count of days between an arbitrary but consistent epoch and the given date.

    See: https://stackoverflow.com/questions/12862226/the-implementation-of-calculating-the-number-of-days-between-2-dates
    """
    # Shift to begin the year in march.
    month = (month + 9) % 12
    year = year - month // 10

    days_since_march_first = (month * 306 + 5) // 10
    return (
        365 * year
        + year // 4
        - year // 100
        + year // 400
        + days_since_march_first
        + (day - 1)
    )


def diff(one: str, two: str) -> int:
    """Return the count of days between dates `one` and `two`."""
    years_one = days(*(int(s) for s in one.split("-")))
    years_two = days(*(int(s) for s in two.split("-")))
    return years_two - years_one


if __name__ == "__main__":
    import sys

    one = sys.argv[1]
    two = sys.argv[2]
    print(diff(one, two))
