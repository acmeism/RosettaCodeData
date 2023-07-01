Dates=: cutLF noun define
15 May
16 May
19 May
17 June
18 June
14 July
16 July
14 August
15 August
17 August
)

getDayMonth=: |:@:(cut&>)                                  NB. retrieve lists of days and months from dates
keep=: adverb def '] #~ u'                                 NB. apply mask to filter dates

monthsWithUniqueDay=: {./. #~ (1=#)/.                      NB. list months that have a unique day
isMonthWithoutUniqueDay=: (] -.@e. monthsWithUniqueDay)/@getDayMonth  NB. mask of dates with a month that doesn't have a unique day

uniqueDayInMonth=: ~.@[ #~ (1=#)/.                         NB. list of days that are unique to 1 month
isUniqueDayInMonth=: ([ e. uniqueDayInMonth)/@getDayMonth  NB. mask of dates with a day that is unique to 1 month

uniqueMonth=: ~.@] #~ (1=#)/.~                             NB. list of months with 1 unique day
isUniqueMonth=: (] e. uniqueMonth)/@getDayMonth            NB. mask of dates with a month that has 1 unique day
