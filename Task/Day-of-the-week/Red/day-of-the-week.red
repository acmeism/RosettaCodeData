Red []
repeat yy 114 [
  d: to-date reduce [25 12 (2007 + yy )]
  if 7 = d/weekday [ print d ] ;; 7 = sunday
]
;; or
print "version 2"

d: to-date [25 12 2008]
while [d <= 25/12/2121 ] [
  if 7 = d/weekday [
    print rejoin [d/day '. d/month '. d/year ]
  ]
  d/year: d/year + 1
]
