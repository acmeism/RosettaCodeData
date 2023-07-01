/*REXX program computes  Hamming numbers:  1 ──► 20,   # 1691,   and  the one millionth.*/
call hamming       1, 20                         /*show the 1st ──► twentieth Hamming #s*/
call hamming    1691                             /*show the 1,691st Hamming number.     */
call hamming 1000000                             /*show the  1 millionth Hamming number.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
hamming: procedure; arg x,y;  if y==''  then y= x;  w= length(y);  L= length(y-1); p= 2**L
         numeric digits max(9, p + p%4 + p%16)   /*ensure enough decimal digits.        */
                                    #2= 1;    #3= 1;     #5= 1;     @.= 0;       @.1= 1
            do n=2  for y-1
            _2= @.#2 + @.#2                      /*this is faster than:      @.#2 * 2   */
            _3= @.#3 + @.#3 + @.#3               /*  "   "    "     "        @,#3 * 3   */
            _5= @.#5 * 5
                              m= _2              /*assume a minimum (of the 3 Hammings).*/
            if _3  < m   then m= _3              /*is this number less than the minimum?*/
            if _5  < m   then m= _5              /* "   "     "     "    "   "     "    */
                    @.n= format(m,,,,0)          /*now,  assign the next Hamming number.*/
            if _2 == m   then #2= #2 + 1         /*number already defined?   Use next #.*/
            if _3 == m   then #3= #3 + 1         /*   "      "       "        "    "  " */
            if _5 == m   then #5= #5 + 1         /*   "      "       "        "    "  " */
            end   /*n*/                          /* [↑]  maybe assign next Hamming #'s. */
                         do j=x  to y;      say 'Hamming('right(j, w)") ="     @.j / 1
                         end   /*j*/

         say right( 'length of last Hamming number ='     length(@.y / 1), 70);        say
         return
