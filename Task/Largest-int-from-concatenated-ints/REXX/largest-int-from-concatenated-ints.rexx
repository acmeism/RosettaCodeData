/*REXX pgm constructs largest integer  from a list  using concatenation.*/
@.  =                                  /*used to signify  end-of-lists. */
@.1 = '{1, 34, 3, 98, 9, 76, 45, 4}'   /*the   first  list of integers. */
@.2 = '{54, 546, 548, 60}'             /* "   second    "   "     "     */
@.3 = '{ 4,  45,  54,  5}'             /* "    third    "   "     "     */
                                       /* [↓]    process all the lists. */
  do j=1  while  @.j\=='';     $=      /*keep truckin' until exhausted. */
  z=space(translate(@.j, , '])},{([')) /*perform scrubbing on the list. */
  _=length(space(z,0)) + 1             /*determine the largest possible#*/
  if _>digits()  then numeric digits _ /*ensure 'nuff digits for the #. */
                                       /* [↓]  examine each num in list.*/
    do  while  z\=='';       index=1   /*keep examining list until done.*/
    big=isOK(word(z,1))                /*assume first number is biggest.*/

      do k=2  to  words(z); x=isOK(word(z,k))          /*get an integer.*/
      x1=left(x,1); L=max(length(big), length(x))      /*get max length.*/
      if left(x, L, x1)  <<=  left(big, L, left(big,1))   then iterate
      big=x;        index=k            /*we found a new biggie (& index)*/
      end   /*k*/                      /* [↑]  find max concatenated int*/

    z=space(delword(z, index, 1))      /*remove the "maximum" from list.*/
    $=$ || big                         /*append the "maximum"  number.  */
    end     /*while z ···*/            /* [↑]  process all nums in list.*/

  say right($,digits())  ' max for: '  @.j    /*show max integer & list.*/
  end       /*j*/                      /* [↑]  process each list of nums*/

exit                                   /*stick a fork in it, we're done.*/
/*───────────────────────────────────ISOK subroutine────────────────────*/
isOK: parse arg ?; if datatype(?,'W')  then return abs(?)/1  /*normalize*/
say;  say '***error!*** number '  ?  "isn't an integer.";   say;   exit 13
