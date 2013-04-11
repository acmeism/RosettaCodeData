require 'types/datetime numeric'
find5wkdMonths=: verb define
  years=. range 2{. y
  months=. 1 3 5 7 8 10 12
  m5w=. (#~ 0 = weekday) >,{years;months;31   NB. 5 full weekends iff 31st is Sunday(0)
  >'MMM YYYY' fmtDate toDayNo m5w
)
