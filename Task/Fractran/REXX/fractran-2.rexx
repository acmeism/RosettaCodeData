/*REXX program runs  FRACTRAN  for a given set of  fractions  and  from a specified  N. */
numeric digits 999;        w= length( digits() ) /*be able to handle gihugeic numbers.  */
parse arg N terms fracs                          /*obtain optional arguments from the CL*/
if N==''     |     N==","  then     N=   2       /*Not specified?  Then use the default.*/
if terms=='' | terms==","  then terms= 100       /* "      "         "   "   "      "   */
if fracs=''                then fracs= '17/91, 78/85, 19/51, 23/38, 29/33, 77/29, 95/23,',
                                       '77/19, 1/17, 11/13, 13/11, 15/14, 15/2, 55/1'
                                                 /* [↑]  The default for the fractions. */
f=space(fracs, 0)                                /*remove all blanks from the FRACS list*/
                   do #=1  while f\=='';    parse var  f    n.#   '/'   d.#   ","   f
                   end   /*#*/                   /* [↑]  parse all the fractions in list*/
#= # - 1                                         /*adjust the number of fractions found.*/
tell= terms>0                                    /*flag:  show number  or  a power of 2.*/
!.= 0;                              _= 1         /*the default value  for powers of  2. */
if \tell  then do p=1  until length(_)>digits();        _= _ + _;              !._= 1
               if p==1  then @._= left('', w + 9)        "2**"left(p, w)    ' '
                        else @._= '(prime' right(p, w)")  2**"left(p, w)    ' '
               end   /*p*/                       /* [↑]  build   powers of 2   tables.  */
L= length(N)                                     /*length in decimal digits of integer N*/
say #  'fractions:'  fracs                       /*display number and actual fractions. */
say 'N  is starting at '  N                      /*display the starting number   N.     */
if tell  then say terms  ' terms are being shown:'                     /*display header.*/
         else say 'only powers of two are being shown:'                /*   "       "   */
q='(max digits used:'                            /*a literal used in the   SAY   below. */

  do j=1  for  abs(terms)                        /*perform DO loop once for each  term. */
      do k=1  for  #                             /*   "     "   "    "   "    " fraction*/
      if N // d.k \== 0  then iterate            /*Not an integer?  Then ignore it.     */
      if tell then say right('term' j, 35)   "──► "   N      /*display Nth term and N.*/
              else if !.N  then say right('term' j,15)  "──►"   @.N  q  right(L,w)")  "  N
      N= N  %  d.k  *  n.k                       /*calculate next term (use %≡integer ÷)*/
      L= max(L, length(N) )                      /*the maximum number of decimal digits.*/
      iterate j                                  /*go start calculating the next term.  */
      end   /*k*/                                /* [↑]  if an integer, we found a new N*/
  end       /*j*/                                /*stick a fork in it,  we're  done.    */
