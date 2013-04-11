/*REXX program computes Hamming numbers: 1──►20,  #1691,  one millionth.*/
numeric digits 100                     /*ensure we have enough precision*/
call hamming 1, 20                     /*show the first ──► twentieth #s*/
call hamming 1691                      /*show the 1,691st Hamming number*/
call hamming 1000000                   /*show the  one millionth  number*/
call hamming 10000000                  /*show the 10th millionth  number*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────HAMMING subroutine──────────────────*/
hamming:  procedure;   parse arg x,y;   if y=='' then y=x;     w=length(y)
          #2=1;     #3=1;     #5=1;     @.=0;    @.1=1

   do n=2  for y-1
   @.n = min(2*@.#2, 3*@.#3, 5*@.#5)   /*pick the minimum of three pigs.*/
   if 2*@.#2 == @.n   then #2 = #2+1   /*# already defined?  Use next #.*/
   if 3*@.#3 == @.n   then #3 = #3+1   /*"    "       "       "    "  " */
   if 5*@.#5 == @.n   then #5 = #5+1   /*"    "       "       "    "  " */
   end   /*n*/
                  do j=x  to y         /*W  is used to align the index. */
                  say 'Hamming('right(j,w)") ="  @.j   /*list 'em, Dano.*/
                  end   /*j*/

say right( 'length of last Hamming number ='  length(@.y),  70);       say
return
