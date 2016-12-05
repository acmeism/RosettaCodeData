/*REXX program calculates and displays the equilibrium index for a numeric array (list).*/
parse arg x                                      /*obtain the optional arguments from CL*/
if x=''  then x=copies(" 7 -7", 50)   7          /*Not specified?  Then use the default.*/
say '         array list: '  space(x)            /*echo the array list to the terminal. */
n=words(x)                                       /*the number of numbers in the  X list.*/
              do j=0  for n                      /*zero─start is for zero─based array.  */
              A.j=word(x, j+1)                   /*define the array element ───►  A.j   */
              end   /*j*/                        /* [↑]  assign   A.0   A.1   A.3  ···  */
say                                              /*  ··· and also display a blank line. */
ans=equilibriumIDX(n)                            /*calculate the  equilibrium index.    */
say 'equilibrium'    word("indices index", 1 + (words(ans==1)))': '     ans
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
equilibriumIDX: procedure expose A.; parse arg # /*expose the array  A.   (make global).*/
$=                                               /*equilibrium indices  (so far).       */
                          do   i=0  for #; sum=0
                            do k=0  for #; sum=sum + A.k*sign(k-i);  end  /*k*/
                          if sum=0  then $=$ i
                          end   /*i*/
if $==''  then $="(none)"                        /*adjust if  no indices  were found.   */
return strip($)                                  /*return the  equilibrium list.        */
