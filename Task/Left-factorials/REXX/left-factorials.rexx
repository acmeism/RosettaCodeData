/*REXX program computes/display the left factorial (or its dec. width) of N (or a range)*/
parse arg bot top inc .                          /*obtain optional arguments from the CL*/
if bot=='' | bot==","  then bot=   1             /*Not specified:  Then use the default.*/
if top=='' | top==","  then top= bot             /* "      "         "   "   "     "    */
if inc=''  | inc==","  then inc=   1             /* "      "         "   "   "     "    */
tell=  bot<0                                     /*if BOT < 0,   only show # of digits. */
bot= abs(bot)                                    /*use the  │bot│  for the   DO   loop. */
w= length(top)                                   /*width of the largest number request. */
              do j=bot  to top  by inc           /*traipse through the numbers requested*/
              if tell  then say 'left ! of '  right(j,w) " ───► " length(L!(j))  ' digits'
                       else say 'left ! of '  right(j,w) " ───► "        L!(j)
              end   /*j*/                        /* [↑]  show either  L!  or # of digits*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
L!: procedure; parse arg x .;  if x<3  then return x;   $= 4;  != 2    /*some shortcuts.*/
             do #=3  to x-1;   != ! * #          /*compute  L!  for all numbers ─── ► X.*/
             if pos(., !)\==0  then numeric digits digits() * 3 % 2    /*bump dec. digs.*/
             $= $ + !                            /*add the factorial ───►  L!  sum.     */
             end   /*#*/                         /* [↑]  handles gihugeic numbers.      */
    return $                                     /*return the sum  (L!)  to the invoker.*/
