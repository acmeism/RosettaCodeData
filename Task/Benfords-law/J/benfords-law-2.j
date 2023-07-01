   First1000Fib=: (, +/@:(_2&{.)) ^: (1000-#) 1 1
   NB. Expected vs Actual frequencies for Digits 1-9
   Digits ((] ,. benford)@"."0@[ ,. (freq firstSigDigits)) First1000Fib
1   0.30103 0.301
2  0.176091 0.177
3  0.124939 0.125
4   0.09691 0.096
5 0.0791812  0.08
6 0.0669468 0.067
7 0.0579919 0.056
8 0.0511525 0.053
9 0.0457575 0.045
