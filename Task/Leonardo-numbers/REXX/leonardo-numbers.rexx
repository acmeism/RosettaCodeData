/*REXX pgm computes Leonardo numbers, allowing the specification of L(0), L(1), and ADD#*/
numeric digits 500                               /*just in case the user gets ka-razy.  */
@.=1                                             /*define the default for the  @. array.*/
parse arg N L0 L1 a# .                           /*obtain optional arguments from the CL*/
if  N =='' |  N ==","  then    N= 25             /*Not specified?  Then use the default.*/
if L0\=='' & L0\==","  then  @.0= L0             /*Was     "         "   "   "   value. */
if L1\=='' & L1\==","  then  @.1= L1             /* "      "         "   "   "     "    */
if a#\=='' & a#\==","  then  @.a= a#             /* "      "         "   "   "     "    */
say 'The first '   N   " Leonardo numbers are:"  /*display a title for the output series*/
if @.0\==1 | @.1\==1  then say 'using '     @.0     " for L(0)"
if @.0\==1 | @.1\==1  then say 'using '     @.1     " for L(1)"
if @.a\==1            then say 'using '     @.a     " for the  add  number"
say                                              /*display blank line before the output.*/
$=                                               /*initialize the output line to "null".*/
             do j=0  for N                       /*construct a list of Leonardo numbers.*/
             if j<2  then z=@.j                  /*for the 1st two numbers, use the fiat*/
                     else do                     /*··· otherwise, compute the Leonardo #*/
                          _=@.0                  /*save the old primary Leonardo number.*/
                          @.0=@.1                /*store the new primary number in old. */
                          @.1=@.0  +  _  +  @.a  /*compute the next Leonardo number.    */
                          z=@.1                  /*store the next Leonardo number in Z. */
                          end                    /* [↑]  only 2 Leonardo #s are stored. */
             $=$ z                               /*append the just computed # to $ list.*/
             end   /*j*/                         /* [↓]  elide the leading blank in  $. */
say strip($)                                     /*stick a fork in it,  we're all done. */
