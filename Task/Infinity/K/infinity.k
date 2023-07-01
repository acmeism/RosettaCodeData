   / Integer infinities
   / 0I is just 2147483647
   / -0I is just -2147483647
   / -2147483648 is a special "null integer"(NaN) 0N
   0I*0I
1
   0I-0I
0
   0I+1
0N
   0I+2
-0I
   0I+3 / -0I+1
-2147483646
   0I-1
2147483646
   0I%0I
1
   0I^2
4.611686e+18
   0I^0I
0i
   0I^-0I
0.0
   1%0
0I
   0%0
0
   0i^2
0i
   0i^0i
0i

   / Floating point infinities in K are something like
   / IEEE 754 values
   / Also there is floating point NaN -- 0n
   0i+1
0i
   0i*0i
0i
   0i-0i
0n
   0i%0i
0n
   0i%0n
0n
   / but
   0.0%0.0
0.0
