/*REXX program  calculates and displays the  digital root  and  additive persistence.   */
say 'digital'                                    /*display the  1st  line of the header.*/
say "  root  persistence" center('number',77)    /*   "     "   2nd    "   "  "     "   */
say "═══════ ═══════════"   left('', 77, "═")    /*   "     "   3rd    "   "  "     "   */
call digRoot       627615
call digRoot        39390
call digRoot       588225
call digRoot 393900588225
call digRoot 89999999999999999999999999999999999999999999999999999999999999999999999999999
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
digRoot: procedure;  parse arg x 1 ox            /*get the number, also get another copy*/
             do pers=0  while length(x)\==1; $=0 /*keep summing until digRoot ≡ 1 digit.*/
               do j=1  for length(x)             /*add each digit in the decimal number.*/
               $=$+substr(x,j,1)                 /*add a decimal digit to digital root. */
               end   /*j*/
             x=$                                 /*a  'new' num,  it may be multi-digit.*/
             end     /*pers*/
         say center(x,7)   center(pers,11)   ox  /*display a nicely formatted line.     */
         return
