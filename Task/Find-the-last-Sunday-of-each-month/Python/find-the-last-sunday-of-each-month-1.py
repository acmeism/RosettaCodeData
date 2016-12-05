import sys
import calendar

year = 2013
if len(sys.argv) > 1:
    try:
        year = int(sys.argv[-1])
    except ValueError:
        pass

for month in range(1, 13):
    last_sunday = max(week[-1] for week in calendar.monthcalendar(year, month))
    print('{}-{}-{:2}'.format(year, calendar.month_abbr[month], last_sunday))
