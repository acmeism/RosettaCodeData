/*REXX pgm shows ranges of numbers with  ordinal (st/nd/rd/th) suffixes.*/
call tell     0,    25                 /*show the 1st range of numbers. */
call tell   250,   265                 /*  "   "  2nd   "    "    "     */
call tell  1000,  1025                 /*  "   "  3rd   "    "    "     */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────TELL subroutine─────────────────────*/
tell: procedure;  parse arg L,H;   $=  /*get Low & High #s, nullify list*/
                  do j=L  to  H        /*process the range, low───►high.*/
                  $=$ j || th(j)       /*append the  Nth  number to list*/
                  end   /*j*/          /* [↑]   $  has a leading blank. */
say 'numbers from '  L  " to "  H  ' (inclusive):'  /*display the title.*/
say strip($)                                        /*display the list. */
say                                                 /*display blank line*/
return                                              /*return to invoker.*/
/*──────────────────────────────────TH subroutine───────────────────────*/
th: procedure;   parse arg x;    x=abs(x)           /*just use ABS value*/
return  word('th st nd rd',  1 + x//10 * (x//100%10 \== 1) * (x//10 < 4) )
