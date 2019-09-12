/*REXX program runs  FRACTRAN  for a given set of  fractions  and  from a specified  N. */
numeric digits 2000                              /*be able to handle larger numbers.    */
parse arg N terms fracs                          /*obtain optional arguments from the CL*/
if N==''     |     N==","  then     N= 2         /*Not specified?  Then use the default.*/
if terms=='' | terms==","  then terms= 100       /* "      "         "   "   "      "   */
if fracs=''                then fracs= '17/91, 78/85, 19/51, 23/38, 29/33, 77/29, 95/23,',
                                       '77/19, 1/17, 11/13, 13/11, 15/14, 15/2, 55/1'
                                                 /* [↑]  The default for the fractions. */
f= space(fracs, 0)                               /*remove all blanks from the FRACS list*/
                   do #=1  while f\=='';    parse var  f   n.#   '/'   d.#   ","   f
                   end   /*#*/                   /* [↑]  parse all the fractions in list*/
#= # - 1                                         /*the number of fractions just found.  */
say #   'fractions:'   fracs                     /*display number and actual fractions. */
say 'N  is starting at '   N                     /*display the starting number  N.      */
say terms   ' terms are being shown:'            /*display a kind of header/title.      */

    do     j=1  for  terms                       /*perform the DO loop for each   term. */
        do k=1  for  #                           /*   "     "   "   "   "    "  fraction*/
        if N // d.k \== 0  then iterate          /*Not an integer?  Then ignore it.     */
        say right('term' j, 35)    "──► "    N   /*display the  Nth  term  with the  N. */
        N= N  %  d.k  *  n.k                     /*calculate next term (use %≡integer ÷)*/
        iterate j                                /*go start calculating the next term.  */
        end   /*k*/                              /* [↑]  if an integer, we found a new N*/
    end       /*j*/                              /*stick a fork in it,  we're all done. */
