import datetime

def is_leap_year(year):
    try:
        datetime.date(year, 2, 29)
    except ValueError:
        return False
    return True
