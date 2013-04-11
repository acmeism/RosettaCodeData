   is_perfect 33550336
1
   }.I. is_perfect"0 i. 10000
6 28 496 8128

   ] zero_through_twentynine =. i. 3 10
 0  1  2  3  4  5  6  7  8  9
10 11 12 13 14 15 16 17 18 19
20 21 22 23 24 25 26 27 28 29
   is_pos_int=: 0&< *. ]=>.
   (is_perfect"0 *. is_pos_int) zero_through_twentynine
0 0 0 0 0 0 1 0 0 0
0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 1 0
