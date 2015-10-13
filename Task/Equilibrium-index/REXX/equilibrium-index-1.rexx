/*REXX program finds the  equilibrium index  for a numeric array (list). */
parse arg x                            /*get array's numbers from the CL.*/
if x=''  then x=copies(' 7 -7',50)  7  /*Nothing given?  Generate a list.*/
say '         array list: '  space(x)  /*echo the array list to screen.  */
n=words(x)                             /*the number of words in the list.*/
              do j=0  for n            /*0─start is for zero─based array.*/
              A.j=word(x, j+1)         /*define the array element.       */
              end   /*j*/              /* [↑]  assign  A.0  A.1  A.3 ··· */
say                                    /*··· and also show a blank line. */
ans=equilibrium_index(n)               /*calculate the equilibrium index.*/
say 'equilibrium'    word('indices index', 1 + (words(ans==1)))": "     ans
exit                                   /*stick a fork in it, we're done. */
/*──────────────────────────────────EQUILIBRIUM_INDEX subroutine─────────*/
equilibrium_index: procedure expose A. /*have the array   A.  be exposed.*/
parse arg #                            /*stemmed array    A.  starts at 0*/
$=                                     /*equilibrium indices  (so far).  */
     do   i=0  for #;  sum=0
       do k=0  for #;  sum=sum + A.k*sign(k-i);  end  /*k*/
     if sum=0  then $=$ i
     end   /*i*/
if $==''  then $="(none)"              /*adjust if no indices are found. */
return strip($)                        /*return the equilibrium list.    */
