   NB. 16bfedcba987654321 loses precision and so we need to work in extended data type

   [ HEX_DIGITS =: >: i. _15x
15 14 13 12 11 10 9 8 7 6 5 4 3 2 1

   [ LCM =: *./ HEX_DIGITS
360360

   ] START =: <.&.(%&LCM)16#.HEX_DIGITS
1147797409030632360

   Until =: conjunction def 'u^:(0-:v)^:_'
   assert 9 -: >:Until(>&8)1

   test=: 0 -.@e. HEX_DIGITS e. 16&#.inv

   [ SOLUTION =: -&LCM Until test START
1147797065081426760

   '16b' , (16 #.inv SOLUTION) { Num_j_ , 26 }. Alpha_j_
16bfedcb59726a1348
