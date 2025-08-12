/*REXX program adds and multiplies N elements of a (populated) array  x.      */
numeric digits 100                     /*100 decimal digit #s  (default is 9).*/
parse arg N .;  if N==''  then N=20    /*Not specified?  Then use the default.*/

do j=1 for N                           /*build array of  N  elements (or 20?).*/
  x.j=j                                /*set 1st to 1, 3rd to 3, 8th to 8 ··· */
  end   /*j*/
sum=0                                  /*initialize  SUM  (variable) to zero. */
prod=1                                 /*initialize  PROD (variable) to one   */
do k=1 for N
  sum  = sum  + x.k                    /*add the element to the running total.*/
  prod = prod * x.k                    /*multiply element to running product. */
  end   /*k*/                          /* [?]  this pgm:  same as N factorial.*/

say '     sum of ' N ' elements for the  x  array is: ' sum
say ' product of ' N ' elements for the  x  array is: ' prod
