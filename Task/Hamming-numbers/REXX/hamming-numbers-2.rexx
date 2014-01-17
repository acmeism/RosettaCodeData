/*REXX program computes Hamming numbers: 1──►20,  #1691,  one millionth.*/
numeric digits 100                     /*ensure we have enough precision*/
call hamming 1, 20                     /*show the first ──► twentieth #s*/
call hamming 1691                      /*show the 1,691st Hamming number*/
call hamming 1000000                   /*show the  one millionth number.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────HAMMING subroutine──────────────────*/
hamming:  procedure;   parse arg x,y;   if y=='' then y=x;     w=length(y)
          #2=1;     #3=1;     #5=1;     @.=0;    @.1=1

   do n=2  for y-1
   _2 = @.#2 + @.#2                    /*this is faster than   2 * @.#2 */
   _3 =    3 * @.#3
   _5 =    5 * @.#5
                     m =_2             /*assume a minimum (of the three)*/
   if _3  < m   then m =_3             /*is this less than the minimum? */
   if _5  < m   then m =_5             /* "   "    "    "   "     "     */
      @.n = m                          /*now, assign the next Hamming #.*/
   if _2 == m   then #2 = #2 + 1       /*# already defined?  Use next #.*/
   if _3 == m   then #3 = #3 + 1       /*"    "       "       "    "  " */
   if _5 == m   then #5 = #5 + 1       /*"    "       "       "    "  " */
   end   /*n*/
                  do j=x  to y         /*W  is used to align the index. */
                  say 'Hamming('right(j,w)") ="  @.j   /*list 'em, Dano.*/
                  end   /*j*/

say right( 'length of last Hamming number ='  length(@.y),  70);       say
return
