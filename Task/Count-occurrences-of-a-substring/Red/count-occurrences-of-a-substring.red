Red []
;;-----------------------------------
count-sub1: func [hay needle][
;;-----------------------------------
  prin rejoin ["hay: " pad copy hay  20 ",needle: " pad copy needle 6  ",count: " ]
  i: 0
  parse hay [ some [thru needle (i: i + 1)] ]
  print i
]
;;-----------------------------------
count-sub2: func [hay needle][
;;-----------------------------------
  prin rejoin ["hay: " pad copy hay  20 ",needle: " pad copy needle 6  ",count: " ]
  i: 0
  while [hay: find hay needle][
    i: i + 1
    hay:  skip hay length? needle
  ]
  print i
]
count-sub1 "the three truths" "th"
count-sub1 "ababababab" "abab"
print "^/version 2"
count-sub2 "the three truths" "th"
count-sub2 "ababababab" "abab"
