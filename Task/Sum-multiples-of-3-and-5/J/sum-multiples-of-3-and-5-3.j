   first =: 0&{
   last =: first + skip * <.@:(skip %~ <:@:(1&{) - first)
   skip =: 2&{
   terms =: >:@:<.@:(skip %~ last - first)
   sum_arithmetic_series =: -:@:(terms * first + last)  NB. sum_arithmetic_series FIRST LAST SKIP
                                                        NB. interval is [FIRST, LAST)
                                                        NB. sum_arithmetic_series is more general than required.

   (0,.10 10000 10000000000000000000x)(,"1 0"1 _)3 5 15x  NB. demonstration: form input vectors for 10, ten thousand, and 1*10^(many)
0                   10  3
0                   10  5
0                   10 15

0                10000  3
0                10000  5
0                10000 15

0 10000000000000000000  3
0 10000000000000000000  5
0 10000000000000000000 15



   (0,.10 10000 10000000000000000000x)+`-/"1@:(sum_arithmetic_series"1@:(,"1 0"1 _))3 5 15x
23 23331668 23333333333333333331666666666666666668
