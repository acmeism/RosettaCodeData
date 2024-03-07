func$ repstr s$ .
   sl = len s$ div 2 + 1
   while sl > 1
      r$ = substr s$ sl 999
      if r$ = substr s$ 1 len r$
         return substr r$ 1 (sl - 1)
      .
      sl -= 1
   .
   return ""
.
repeat
   s$ = input
   until s$ = ""
   print s$ & " -> " & repstr s$
.
input_data
1001110011
1110111011
0010010010
1010101010
1111111111
0100101101
0100100
101
11
00
1
