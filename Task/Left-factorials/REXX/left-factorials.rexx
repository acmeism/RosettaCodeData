/*REXX pgm computes/shows the left factorial (or width) of N (or range).*/
parse arg bot top inc .                /*obtain optional args from C.L. */
if bot==''  then bot=1                 /*BOT defined?  Then use default.*/
td= bot<0                              /*if BOT < 0,   only show # digs.*/
bot=abs(bot)                           /*use the |bot|  for the DO loop.*/
if top==''  then top=bot               /* "   "   top    "   "   "   "  */
if inc=''   then inc=1                 /* "   "   inc    "   "   "   "  */
@='left ! of '                         /*a literal used in the display. */
w=length(H)                            /*width of largest number request*/
           do j=bot  to top  by inc    /*traipse through  #'s requested.*/
           if td  then say @ right(j,w)  " ───► "  length(L!(j)) ' digits'
                  else say @ right(j,w)  " ───► "  L!(j)
           end   /*j*/                  /* [↑]  show either L! or #digits*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────L! subroutine───────────────────────*/
L!: procedure; parse arg x .;  if x<3  then return x;  s=4  /*shortcuts.*/
!=2;     do f=3  to x-1                /*compute L! for all numbers───►X*/
         !=!*f                         /*compute intermediate factorial.*/
         if pos(.,!)\==0 then numeric digits digits()*1.5%1 /*bump digs.*/
         s=s+!                         /*add the factorial ───► L!  sum.*/
         end   /*f*/                   /* [↑]  handles gi-hugeic numbers*/
return s                               /*return the sum (L!) to invoker.*/
