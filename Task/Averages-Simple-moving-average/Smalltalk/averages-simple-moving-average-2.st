|sma3 sma5|

sma3 := MovingAverage newWithPeriod: 3.
sma5 := MovingAverage newWithPeriod: 5.

#( 1 2 3 4 5 5 4 3 2 1 ) do: [ :v |
  ('Next number %1, SMA_3 = %2, SMA_5 = %3' % {
         v . (sma3 add: v) asFloat . (sma5 add: v) asFloat
    }) displayNl
]
