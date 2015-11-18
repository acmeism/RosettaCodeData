from datetime import date

for year in range(2008, 2122):
    day = date(year, 12, 25)
    if day.weekday() == 6:
        print(day.strftime('%d %b %Y'))
