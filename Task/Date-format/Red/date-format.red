Red []
;; zeropad
f2n: func [d] [ if  d > 9 [return d ]   append copy "0" d  ]

d: now/date

print rejoin [d/year "-" f2n d/month "-" f2n d/day]
print rejoin [system/locale/days/(d/weekday) ", " system/locale/months/(d/month) " " f2n d/day ", " d/year]
