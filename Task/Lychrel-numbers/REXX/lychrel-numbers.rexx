/*REXX program finds and displays  Lychrel numbers,  related numbers, and  palindromes. */
parse arg high limit .                           /*obtain optional argument from the CL.*/
if  high='' |  high==","  then  high= 10000      /*Not specified?  Then use the default.*/
if limit='' | limit==","  then limit=   500      /* "      "         "   "   "     "    */
numeric digits  limit % 2                        /*ensure enough decimal digits for adds*/
T.= 0;   @.= T.;   #.=@.;     w= length(high)    /*W:   is used for formatting numbers. */
$=                                               /*the list of  Lychrel  numbers.       */
    do j=1  for high;         call Lychrel j     /*find the    Lychrel   numbers.       */
    end   /*j*/
p=;                           R=                 /*P: list of palindromes; R: related #s*/
    do k=1  for high
    if #.k                    then $= $ k        /*build a list of Lychrel numbers.     */
    if T.k                    then R= R k        /*  "   "   "   "    "    related nums.*/
    if T.k  &  k==reverse(k)  then p= p k        /*  "   "   "   "    "    palindromes. */
    end   /*k*/

say 'Found in the range  1  to '   high    " (limiting searches to "    limit   ' steps):'
say
say right( words($)           , w)         'Lychrel numbers:'             $
say right( words(R) - words($), w)         'Lychrel related numbers.'
say right( words(p)           , w)         'Lychrel palindromes:'         p
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
Lychrel: procedure expose limit @. #. T.; parse arg x 1 z   /*set X and Z to argument 1.*/
         rels= 0                                            /*# related numbers (so far)*/
                   do  limit;             z= z + reverse(z) /*add the reverse of Z ···  */
                   if z==reverse(z)  then return            /*is the new Z a palindrome?*/
                   rels= rels + 1;        !.rels= z         /*add to the related numbers*/
                   end   /*limit*/                          /* [↑]  only DO limit times.*/
         #.x= 1                                             /*mark number as a  Lychrel.*/
         T.x= 1;   do a=1  for rels;      _= !.a            /*process "related" numbers.*/
                   if @._  then #.x= 0                      /*unmark number as  Lychrel.*/
                           else @._= 1                      /*  mark    "    "    "     */
                   T._= 1                                   /*mark number as  "related".*/
                   end   /*a*/
         return
