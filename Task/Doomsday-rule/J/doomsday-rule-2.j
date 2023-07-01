get_weekday=: {{ 'Y M D'=. y
  Y0=. todayno Y,1 1
  Y1=. todayno 1+Y,0 0
  aday=. M{_,1+7|1++/\.>.//./}.|:todate Y0+i.Y1-Y0
  dday=. 7|2 5 4 6+/ .*1,4 100 400|/Y
  'day',~;(7|D+dday-aday){;:'Sun Mon Tues Wednes Thurs Fri Satur'
}}
