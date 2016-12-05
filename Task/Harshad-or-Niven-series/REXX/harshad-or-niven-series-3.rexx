/*REXX program finds the first  A  Niven numbers;  it also finds first Niven number > B.*/
parse arg A B .                                  /*obtain optional arguments from the CL*/
if A=='' | A==','  then A=  20                   /*Not specified?  Then use the default.*/
if B=='' | B==','  then B=1000                   /* "      "         "   "    "     "   */
numeric digits 1+max(8, length(A), length(B))    /*enable the use of any sized numbers. */
#=0;    $=                                       /*set Niven numbers count;  Niven list.*/
                           do j=1  until  #==A   /*◄───── let's go Niven number hunting.*/
                           if isNiven(j)  then do;  #=#+1;  $=$ j;  end
                           end   /*j*/           /* [↑]   bump count; append J ──► list.*/

say 'first'   A   'Niven numbers:'   $

   do t=B+1  until  isNiven(t);      end         /*hunt for a Niven (or Harshad) number.*/

say  'first Niven number >'     B      " is: "      t
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
isNiven: procedure;  parse arg x 1 sum 2 q       /*use the first decimal digit for  SUM.*/
                           do  while  q\=='';  parse var q _ 2 q;  sum=sum+_;   end  /*k*/
                                                 /*      ↑                              */
         return x//sum==0                        /*      └───◄ is destructively parsed. */
