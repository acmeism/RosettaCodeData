/*REXX program tests the  LCS  (Longest Common Subsequence)  subroutine.                */
parse arg aaa bbb .                              /*obtain optional arguments from the CL*/
say 'string A ='     aaa                         /*echo the string   A   to the screen. */
say 'string B ='     bbb                         /*  "   "     "     B    "  "     "    */
say '     LCS ='     LCS(aaa, bbb)               /*tell the  Longest Common Sequence.   */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
LCS: procedure; parse arg a,b,z                  /*Longest Common Subsequence.          */
                                                 /*reduce recursions, removes the       */
                                                 /*chars in  A ¬ in B,   and vice─versa.*/
     if z==''  then return LCS( LCS(a,b,0), LCS(b,a,0), 9)   /*Is Z null?   Do recurse. */
     j= length(a)
     if z==0 then do                             /*a special invocation:  shrink  Z.    */
                                      do j=1  for j;                 _= substr(a, j, 1)
                                      if pos(_, b)\==0  then z= z || _
                                      end   /*j*/
                  return substr(z, 2)
                  end
     k= length(b)
     if j==0 | k==0  then return ''              /*Is either string null?    Bupkis.    */
        _= substr(a, j, 1)
     if _==substr(b, k, 1)  then return LCS( substr(a, 1, j - 1), substr(b, 1, k - 1), 9)_
     x= LCS(a, substr(b, 1, k - 1), 9)
     y= LCS(   substr(a, 1, j - 1), b, 9)
     if length(x)>length(y)  then return x
                                  return y
