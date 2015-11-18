/*REXX program constructs  largest integer  from a list  using concatenation. */
@.  =.;          @.1 = '{1, 34, 3, 98, 9, 76, 45, 4}'  /*the 1st integer list.*/
                 @.2 = '{54, 546, 548, 60}'            /* "  2nd    "      "  */
                 @.3 = '{ 4,  45,  54,  5}'            /* "  3rd    "      "  */
                                       /* [↓]   process all the integer lists.*/
  do j=1  while  @.j\==.;      $=      /*keep truckin' until lists exhausted. */
  z=space(translate(@.j, , '])},{([')) /*perform scrubbing on the number list.*/
  _=length(space(z, 0))  + 1           /*determine the  largest possibility.  */
  if _>digits()  then numeric digits _ /*use enough decimal digits for maximum*/
                                       /* [↓]  examine each number in the list*/
       do  while  z\=='';     index=1  /*keep examining the list  until  done.*/
       big=isOK(word(z,1))             /*assume that first number is biggest. */

         do k=2  to  words(z);     #=isOK(word(z,k))      /*get an integer.   */
         L=max(length(big), length(#))                    /*get maximum length*/
         if left(#, L, left(#,1))  <<=  left(big, L, left(big,1))   then iterate
         big=#;        index=k         /*we found a new biggie (and the index)*/
         end   /*k*/                   /* [↑]  find max concatenated integer. */

       z=space(delword(z, index, 1))   /*remove this maximum #  from the list.*/
       $=$ || big                      /*append this maximum #  number to  $. */
       end     /*while z ··· */        /* [↑]  process all integers in a list.*/

     say right($,digits())  ' max for: '  @.j  /*show maximum integer and list*/
     end       /*j*/                   /* [↑]  process each list of numbers.  */
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
isOK: parse arg ?;  if datatype(?,'W')  then return abs(?)/1; say  /*normalize*/
      say '***error!***  number '   ?   "isn't an integer.";  say;      exit 13
