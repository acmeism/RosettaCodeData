import datetime

weekDays = ("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday")
thisXMas  = datetime.date(2021,12,25)
thisXMasDay = thisXMas.weekday()
thisXMasDayAsString = weekDays[thisXMasDay]
print("This year's Christmas is on a {}".format(thisXMasDayAsString))

nextNewYear = datetime.date(2022,1,1)
nextNewYearDay = nextNewYear.weekday()
nextNewYearDayAsString = weekDays[nextNewYearDay]
print("Next new year is on a {}".format(nextNewYearDayAsString))
