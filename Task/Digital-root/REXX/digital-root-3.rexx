/*REXX program  calculates and displays the  digital root  and  additive persistence.   */
say 'digital   additive'                         /*display the  1st  line of the header.*/
say "  root  persistence" center('number',77)    /*   "     "   2nd    "   "  "     "   */
say "═══════ ═══════════"   left('', 77, "═")    /*   "     "   3rd    "   "  "     "   */
say digRoot(       627615)
say digRoot(        39390)
say digRoot(       588225)
say digRoot( 393900588225)
say digRoot(89999999999999999999999999999999999999999999999999999999999999999999999999999)
say "═══════ ═══════════"   left('', 77, "═")    /*display the  foot separator.         */
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
digRoot: procedure;  parse arg x 1 ox;     L=length(x) /*get a number and another copy. */
           do pers=1  until L==1;  $= 0                /*keep summing 'til digRoot≡1 dig*/
                do j=1  for L;     ?= substr(x, j, 1)  /*add each digit in the dec. num.*/
                if datatype(?, 'W')  then $= $ + ?     /*add a dec. dig to digital root.*/
                end   /*j*/
           x= $;                           L=length(x) /*a new #, it may be multi─digit.*/
           end        /*pers*/
         return center(x,7)   center(pers,11)  ox      /*return a nicely formatted line.*/
