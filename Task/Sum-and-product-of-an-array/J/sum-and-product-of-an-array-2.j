   sum 1 3 5 7 9 11 13
49
   product 1 3 5 7 9 11 13
135135

   a=: 3 10 ?@$ 100  NB. random array
   a
90 47 58 29 22 32 55  5 55 73
58 50 40  5 69 46 34 40 46 84
29  8 75 97 24 40 21 82 77  9

   NB. on a table, each row is an item to be summed:
   sum a
177 105 173 131 115 118 110 127 178 166
   product a
151380 18800 174000 14065 36432 58880 39270 16400 194810 55188

   NB. but we can tell J to sum everything within each row, instead:
   sum"1 a
466 472 462
   product"1 a
5.53041e15 9.67411e15 1.93356e15
