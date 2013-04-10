#Still another solution, using ISOdate and weekdays
(2008:2121)[weekdays(ISOdate(2008:2121, 12, 25)) == "Sunday"]

# Simply replace "Sunday" with whatever it's named in your country,
# or set locale first, with
Sys.setlocale(cat="LC_ALL", "en")
