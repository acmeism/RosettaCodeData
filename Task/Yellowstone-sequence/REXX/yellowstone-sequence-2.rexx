/*REXX program calculates any number of terms in the Yellowstone (permutation) sequence.*/
parse arg m .                                    /*obtain optional argument from the CL.*/
if m=='' | m==","  then m= 30                    /*Not specified?  Then use the default.*/
!.= 0                                            /*initialize an array of numbers(used).*/
# = 0                                            /*count of Yellowstone numbers in seq. */
$ =                                              /*list   "      "         "     "  "   */
      do j=1  until #==m;         prev= # - 1
      if j<5  then do;  #= #+1;   @.#= j;  !.#= j;  !.j= 1;  $= strip($ j);  iterate;  end

         do k=1;   if !.k  then iterate          /*Already used?  Then skip this number.*/
         if gcd(k, @.prev)<2  then iterate       /*Not meet requirement?  Then skip it. */
         if gcd(k, @.#) \==1  then iterate       /* "    "       "          "    "   "  */
         #= # + 1; @.#= k;     !.k= 1;   $= $ k  /*bump ctr; assign; mark used; add list*/
         leave                                   /*find the next Yellowstone seq. number*/
         end   /*k*/
      end      /*j*/

call $histo  $   '(vertical)'                    /*invoke a REXX vertical histogram plot*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
gcd: parse arg x,y;  do until y==0;  parse value  x//y  y   with   y  x;  end;    return x
