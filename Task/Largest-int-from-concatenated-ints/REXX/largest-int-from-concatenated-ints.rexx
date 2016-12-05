/*REXX program constructs the largest integer  from an integer list using concatenation.*/
@.=.;     @.1 = '{1, 34, 3, 98, 9, 76, 45, 4}'   /*the  1st  integer list to be used.   */
          @.2 = '{54, 546, 548, 60}'             /* "   2nd     "      "   "  "   "     */
          @.3 = '{ 4,  45,  54,  5}'             /* "   3rd     "      "   "  "   "     */
                                                 /* [↓]   process all the integer lists.*/
  do j=1  while  @.j\==.;      $=                /*keep truckin' until lists exhausted. */
  z=space( translate(@.j, , '])},{([') )         /*perform scrubbing on the integer list*/
  _=length( space(z, 0) )  + 2                   /*determine the  largest  possibility. */
  if _>digits()  then numeric digits _           /*use enough decimal digits for maximum*/
                                                 /* [↓]  examine each number in the list*/
       do  while  z\=='';        index=1         /*keep examining the list  until  done.*/
       big=isOK( word(z, 1) );   LB=length(big)  /*assume that first integer is biggest.*/
                                                 /* [↓]  check the rest of the integers.*/
         do k=2  to  words(z); #=isOK(word(z,k)) /*obtain an an integer from the list.  */
         L=max(LB, length(#) )                   /*get the maximum length of the integer*/
         if left(#, L, left(#, 1) )    <<=    left(big, L, left(big, 1) )    then iterate
         big=#;        index=k                   /*we found a new biggie (and the index)*/
         end   /*k*/                             /* [↑]  find max concatenated integer. */

       z=space( delword(z, index, 1) )           /*delete this maximum integer from list*/
       $=$ || big                                /*append   "     "       "    ───►  $. */
       end     /*while z*/                       /* [↑]  process all integers in a list.*/

     say right($, digits())   ' max for: '   @.j /*show the maximum integer and the list*/
     end       /*j*/                             /* [↑]  process each list of integers. */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
isOK: parse arg ?;  if datatype(?,'W')  then return abs(?)/1    /*normalize the integer.*/
      say;   say '***error***  number '    ?    "isn't an integer.";     say;      exit 13
