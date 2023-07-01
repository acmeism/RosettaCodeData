   cond=: 1&~: *. 4&~:     NB. not equal to 1 and not equal to 4
   sumSqrDigits=: +/@(*:@(,.&.":))

   sumSqrDigits 123        NB. test sum of squared digits
14
   8{. (#~ 1 = sumSqrDigits ^: cond ^:_ "0) 1 + i.100
1 7 10 13 19 23 28 31
