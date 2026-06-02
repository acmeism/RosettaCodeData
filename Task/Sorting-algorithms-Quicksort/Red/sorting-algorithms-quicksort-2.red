Red [
   title: "Quick Sort"
   author: "hinjolicious"
   resources: "Red Sensei, Python's example"
]

quick: function [a][ _quick a 1 length? a ]

_quick: function [a start stop][
   if stop - start <= 0 [return a]

   ; Handles sorted / reversed data better (no recursion stack overflow)
   mid: (start + stop) >> 1

   ;-- Sort start, mid, stop positions (put median at start)
   if a/(start) > a/(mid) [swap at a start at a mid]
   if a/(start) > a/(stop) [swap at a start at a stop]
   if a/(mid) > a/(stop) [swap at a mid at a stop]

   ;-- Now a/(mid) is the median; move it to start position as pivot
   swap at a start at a mid

   piv: a/(start)
   l: start
   r: stop
   while [l <= r][
      while [a/(l) < piv] [l: l + 1]
      while [a/(r) > piv] [r: r - 1]
      if l <= r [
         swap  at a l  at a r
         l: l + 1
         r: r - 1
      ]
   ]
   _quick a start r
   _quick a l stop
]

random/seed 1
max: 10000
dat: collect [loop max [keep random max]]

t: now/time/precise
quick dat
print ["quick: " now/time/precise - t]
print ["sorted: " dat]
