/*REXX program finds the first  A  Niven numbers; also first Niven number > B.*/
parse arg A B .                        /*get optional arguments from the C.L. */
if A=='' | A==','  then A=  20         /*Not specified?  Then use the default.*/
if B=='' | B==','  then B=1000         /* "      "        "   "    "      "   */
numeric digits 1+max(8, length(A), length(B))     /*enable use of any sized #s*/
#=0;  $=                               /*set Niven numbers count;  Niven list.*/

  do j=1  until #==A                   /* [↓]  let's go Niven number hunting. */
  if j//sumDigs(j)==0  then do; #=#+1; $=$ j; end /*bump count; append──►list.*/
  end   /*j*/

say 'first'   A   'Niven numbers:'   $

  do t=B+1 until t//sumDigs(t)==0; end /*hunt for a Niven (or Harshad) number.*/

say  'first Niven number >'    B      " is: "      t
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
sumDigs: procedure;  parse arg x;                s=0
                        do k=1  for length(x);   s=s+substr(x,k,1);   end  /*k*/
         return s
