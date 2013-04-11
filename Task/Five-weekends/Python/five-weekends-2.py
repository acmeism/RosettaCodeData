LONGMONTHS = (1, 3, 5, 7, 8, 10, 12) # Jan Mar May Jul Aug Oct Dec
def fiveweekendspermonth2(start=START, stop=STOP):
    return [date(yr, month, 31)
            for yr in range(START.year, STOP.year)
            for month in LONGMONTHS
            if date(yr, month, 31).timetuple()[6] == 6 # Sunday
            ]

dates2 = fiveweekendspermonth2()
assert dates2 == dates
