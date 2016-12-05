years <- 2008:2121
xmas <- as.POSIXlt(paste0(years, '/12/25'))
years[xmas$wday==0]
# 2011 2016 2022 2033 2039 2044 2050 2061 2067 2072 2078 2089 2095 2101 2107 2112 2118

# Also:
xmas=seq(as.Date("2008/12/25"), as.Date("2121/12/25"), by="year")
as.numeric(format(xmas[weekdays(xmas)== 'Sunday'], "%Y"))

# Still another solution, using ISOdate and weekdays
with(list(years=2008:2121), years[weekdays(ISOdate(years, 12, 25)) == "Sunday"])

# Or with "subset"
subset(data.frame(years=2008:2121), weekdays(ISOdate(years, 12, 25)) == "Sunday")$years

# Simply replace "Sunday" with whatever it's named in your country,
# or set locale first, with
Sys.setlocale(cat="LC_ALL", "en")

# Under MS Windows, write instead
Sys.setlocale("LC_ALL", "English")
