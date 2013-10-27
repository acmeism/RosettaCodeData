/*REXX program finds first X Niven numbers; also first Niven number > Y.*/
parse arg X Y .                        /*get optional arguments:   X  Y */
if X==''  then X=20                    /*Not specified? Then use default*/
if Y==''  then Y=1000                  /*Not specified? Then use default*/
#=0;  $=                               /*Niven# count;  Niven# list.    */

   do j=1  until #==X                  /*let's go Niven number hunting. */
   if j//sumDigs(j)\==0  then iterate  /*Not a Niven number?  Then skip.*/
   #=#+1;  $=$ j                       /*bump Niven# count; add to list.*/
   end   /*j*/

say 'first'  X  'Niven numbers:'  $

   do t=1                              /*let's go Niven number searching*/
   if t//sumDigs(t)\==0  then iterate  /*Not a Niven number?  Then skip.*/
   if t>Y  then leave                  /*if greater than Y, go & show it*/
   end   /*t*/

say  'first Niven number >'    Y      " is: "      t
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SUMDIGS subroutine──────────────────*/
sumDigs: procedure;  parse arg ?;      sum = left(?,1)
             do k=2  to length(?);     sum = sum+substr(?,k,1);  end /*k*/
return sum
