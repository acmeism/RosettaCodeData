from datetime import datetime

def days_between_dates(one: str, two: str) -> int:
    """Return the count of days between dates `one` and `two`."""
    delta = datetime.strptime(two, "%Y-%m-%d") - datetime.strptime(one, "%Y-%m-%d")
    return delta.days

if __name__ == "__main__":
    import sys

    one = sys.argv[1]
    two = sys.argv[2]
    print(days_between_dates(one, two))
