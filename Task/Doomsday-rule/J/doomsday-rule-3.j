get_weekday=: {{ 'Y M D'=. y
  leap=. 0~:/ .=4 100 400|/Y
  aday=. 1+7|(M*leap*3>M)+M{_ 2 6 6 3 1 5 3 0 4 2 6 4
  dday=. 7|2 5 4 6+/ .*1,4 100 400|/Y
  'day',~;(7|D+dday-aday){;:'Sun Mon Tues Wednes Thurs Fri Satur'
}}
