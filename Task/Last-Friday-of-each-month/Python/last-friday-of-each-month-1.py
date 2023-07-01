import calendar

def last_fridays(year):
    for month in range(1, 13):
        last_friday = max(week[calendar.FRIDAY]
            for week in calendar.monthcalendar(year, month))
        print('{:4d}-{:02d}-{:02d}'.format(year, month, last_friday))
