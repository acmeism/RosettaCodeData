/*REXX program to test the  LCS (Longest Common Subsequence) subroutine.*/
parse arg aaa bbb .                    /*get two arguments (strings).   */
say 'string A = 'aaa                   /*echo string  A  to screen.     */
say 'string B = 'bbb                   /*echo string  B  to screen.     */
say '     LCS = 'lcs(aaa,bbb)          /*tell Longest Common Sequence.  */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────LCS subroutine──────────────────────*/
lcs: procedure; parse arg a,b,z        /*Longest Common Subsequence.    */
                                       /*reduce recursions, removes the */
                                       /*chars in A ¬ in B, & vice-versa*/
if z=='' then return lcs( lcs(a,b,0), lcs(b,a,0), 9)
j=length(a)
if z==0 then do                        /*special invocation:  shrink Z. */
                                  do j=1  for j;   _=substr(a,j,1)
                                  if pos(_,b)\==0  then z=z||_
                                  end   /*j*/
             return substr(z,2)
             end
k=length(b)
if j==0 | k==0  then return ''         /*Either string null?    Bupkis. */
_=substr(a,j,1)
if _==substr(b,k,1)  then return lcs(substr(a,1,j-1),substr(b,1,k-1),9)_
x=lcs(a,substr(b,1,k-1),9)
y=lcs(substr(a,1,j-1),b,9)
if length(x)>length(y)  then return x
                             return y
