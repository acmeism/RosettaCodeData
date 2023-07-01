/*REXX program computes  Hamming numbers:  1 ──► 20,  # 1691,  and  the  one millionth. */
numeric digits 100                               /*ensure enough decimal digits.        */
call hamming       1, 20                         /*show the 1st ──► twentieth Hamming #s*/
call hamming    1691                             /*show the 1,691st Hamming number.     */
call hamming 1000000                             /*show the  1 millionth Hamming number.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
hamming: procedure; parse arg x,y;         if y==''  then y= x;       w= length(y)
                                   #2= 1;     #3= 1;      #5= 1;      @.= 0;        @.1= 1
            do n=2  for y-1
            @.n= min(2*@.#2,  3*@.#3,  5*@.#5)   /*pick the minimum of 3 Hamming numbers*/
            if 2*@.#2 == @.n   then #2= #2 + 1   /*number already defined?  Use next #. */
            if 3*@.#3 == @.n   then #3= #3 + 1   /*   "      "       "       "    "  "  */
            if 5*@.#5 == @.n   then #5= #5 + 1   /*   "      "       "       "    "  "  */
            end   /*n*/                          /* [↑]  maybe assign next 3 Hamming#s. */
                         do j=x  to y;     say  'Hamming('right(j, w)") ="    @.j
                         end   /*j*/

         say right( 'length of last Hamming number ='     length(@.y), 70);        say
         return
