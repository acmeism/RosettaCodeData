LONGMONTHS = (1, 3, 5, 7, 8, 10, 12)  # Jan Mar May Jul Aug Oct Dec


def five_weekends_per_month2(start: date = START,
                             stop: date = STOP) -> list[date]:
    return [last_day
            for year in range(start.year, stop.year)
            for month in LONG_MONTHS
            if (last_day := date(year, month, 31)).weekday() == 6]  # Sunday

dates2 = five_weekends_per_month2()
assert dates2 == dates
