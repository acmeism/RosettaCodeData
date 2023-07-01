from datetime import (date,
                      timedelta)

DAY = timedelta(days=1)
START, STOP = date(1900, 1, 1), date(2101, 1, 1)
WEEKEND = {6, 5, 4}  # Sunday is day 6
FMT = '%Y %m(%B)'


def five_weekends_per_month(start: date = START,
                            stop: date = STOP) -> list[date]:
    """Compute months with five weekends between dates"""
    current_date = start
    last_month = weekend_days = 0
    five_weekends = []
    while current_date < stop:
        if current_date.month != last_month:
            if weekend_days >= 15:
                five_weekends.append(current_date - DAY)
            weekend_days = 0
            last_month = current_date.month
        if current_date.weekday() in WEEKEND:
            weekend_days += 1
        current_date += DAY
    return five_weekends


dates = five_weekends_per_month()
indent = '  '
print(f"There are {len(dates)} months of which the first and last five are:")
print(indent + ('\n' + indent).join(d.strftime(FMT) for d in dates[:5]))
print(indent + '...')
print(indent + ('\n' + indent).join(d.strftime(FMT) for d in dates[-5:]))

years_without_five_weekends_months = (STOP.year - START.year
                                      - len({d.year for d in dates}))
print(f"\nThere are {years_without_five_weekends_months} years in the "
      f"range that do not have months with five weekends")
