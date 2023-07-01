/*REXX program finds the first  A  Niven numbers;  it also finds first Niven number > B.*/
parse arg A B .                                  /*obtain optional arguments from the CL*/
if A=='' | A==','  then A=   20                  /*Not specified?  Then use the default.*/
if B=='' | B==','  then B= 1000                  /* "      "         "   "    "     "   */
numeric digits 1+max(8, length(A), length(B) )   /*enable the use of any sized numbers. */
#= 0;      $=                                    /*set Niven numbers count;  Niven list.*/
                        do j=1  until  #==A      /*◄───── let's go Niven number hunting.*/
                        if isNiven(j)  then do;   #= #+1;   $= $ j;   end
                        end   /*j*/              /* [↑]   bump count; append J ──► list.*/
say 'first'   A   'Niven numbers:'   $           /*display list of Niven numbers──►term.*/

                   do t=B+1  until  isNiven(t)   /*hunt for a Niven (or Harshad) number.*/
                   end
say 'first Niven number >'   B    " is: "     t  /*display 1st Niven number >   B.      */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
isNiven: parse arg x 1 sum 2 q                   /*use the 1st decimal digit for  SUM.  */
                 do length(q);              parse var q _ 2 q;          sum= sum + _
                 end   /*length(q)*/             /*   ↑                                 */
         return x // sum == 0                    /*   └──────◄ is destructively parsed. */
