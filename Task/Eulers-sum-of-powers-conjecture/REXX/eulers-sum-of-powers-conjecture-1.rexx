/*REXX program finds unique positive integers for ────────── aⁿ+bⁿ+cⁿ+dⁿ==xⁿ  where n=5 */
parse arg L H N .                                /*get optional  LOW, HIGH,  #solutions.*/
if L=='' | L==","  then L=   0  + 1              /*Not specified?  Then use the default.*/
if H=='' | H==","  then H= 250  - 1              /* "      "         "   "   "     "    */
if N=='' | N==","  then N=   1                   /* "      "         "   "   "     "    */
w= length(H)                                     /*W:  used for display aligned numbers.*/
say center(' 'subword(sourceLine(1), 9, 3)" ", 70 +5*w, '─')  /*show title from 1st line*/
numeric digits 1000                              /*be able to handle the next expression*/
numeric digits max(9, length(3*H**5) )           /* "   "   "    "   3* [H to 5th power]*/
bH= H - 2;                 cH= H - 1             /*calculate the upper  DO  loop limits.*/
!.= 0                                            /* [↓]  define values of  5th  powers. */
       do pow=1  for H;    @.pow= pow**5;     _= @.pow;        !._= 1;          $._= pow
       end   /*pow*/
?.= !.
       do    j=4   for H-3                       /*use the range of:   four  to   cH.   */
          do k=j+1  to H;  _= @.k - @.j;  ?._= 1 /*compute the   xⁿ - dⁿ    differences.*/
          end   /*k*/                            /* [↑]  diff. is always positive as k>j*/
       end      /*j*/                            /*define [↑]    5th  power differences.*/
#= 0                                             /*#:  is the number of solutions found.*/   /* [↓]  for N=∞ solutions.*/
    do       a=L    to H-3                       /*traipse through possible  A  values. */   /*◄──done       246 times.*/
      do     b=a+1  to bH;      s1= @.a + @.b    /*   "       "        "     B    "     */   /*◄──done    30,381 times.*/
        do   c=b+1  to cH;      s2= s1  + @.c    /*   "       "        "     C    "     */   /*◄──done 2,511,496 times.*/
        if ?.s2  then do d=c+1  to H;  s= s2+@.d /*find the appropriate solution.       */
                      if !.s  then call show     /*Is it a solution?   Then display it. */
                      end   /*d*/                /* [↑]    !.S  is a boolean.           */
        end                 /*c*/
      end                   /*b*/
    end                     /*a*/

if #==0  then say "Didn't find a solution.";           exit 0
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: _= left('', 5);     #= # + 1               /*_:  used as a spacer; bump # counter.*/
      say _  'solution'   right(#, length(N))":"  _  'a='right(a, w)   _  "b="right(b, w),
          _  'c='right(c, w)     _    "d="right(d, w)     _    'x='right($.s, w+1)
      if #<N  then return                        /*return, keep searching for more sols.*/
      exit #                                     /*stick a fork in it,  we're all done. */
