/*REXX program  computes/display the  left factorial  (or its width) of  N  (or range). */
parse arg bot top inc .                          /*obtain optional argumenst from the CL*/
if bot=='' | bot==","  then bot=  1              /*Not specified:  Then use the default.*/
if top=='' | top==","  then top=bot              /* "      "         "   "   "     "    */
if inc=''  | inc==","  then inc=  1              /* "      "         "   "   "     "    */
tellDigs= (bot<0)                                /*if BOT < 0,   only show # of digits. */
bot=abs(bot)                                     /*use the  │bot│  for the   DO   loop. */
@= 'left ! of '                                  /*a handy literal used in the display. */
w=length(H)                                      /*width of the largest number request. */
               do j=bot  to top  by inc          /*traipse through the numbers requested*/
               if tellDigs  then say @ right(j,w)   " ───► "   length(L!(j))     ' digits'
                            else say @ right(j,w)   " ───► "          L!(j)
               end   /*j*/                       /* [↑]  show either  L!  or # of digits*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
L!: procedure; parse arg x .;  if x<3  then return x;  s=4        /*some shortcuts.     */
!=2;     do f=3  to x-1                          /*compute  L!  for all numbers ─── ► X.*/
         !=!*f                                   /*compute intermediate factorial.      */
         if pos(.,!)\==0 then numeric digits digits()*1.5%1       /*bump decimal digits.*/
         s=s+!                                   /*add the factorial ───►  L!  sum.     */
         end   /*f*/                             /* [↑]  handles gihugeic numbers.      */
return s                                         /*return the sum  (L!)  to the invoker.*/
