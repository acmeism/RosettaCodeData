   wRoot=: %: W 'obtained square root'
   wIncr=: >: W 'added 1'
   wHalf=: -: W 'divided by 2'
   0{::result=: wHalf`wIncr`wRoot comp unit 5
1.61803
   1{::result
Initial value: 5
obtained square root -> 2.23607
added 1 -> 3.23607
divided by 2 -> 1.61803
