/*REXX program to add and separately multiply elements of an array. */
numeric digits 30            /*allow 30-digit numbers (default is 9)*/
m=20                         /*one method of indicating array size. */
          do j=1  for m      /*build an array of twenty elements.   */
          y.j=j              /*set 1st to 1, 3rd to 3, 9th to 9 ... */
          end   /*j*/
sum=0                        /*initialize  SUM   to zero.           */
prod=1                       /*initialize  PROD  to unity.          */
          do k=1  for m
          sum =sum +y.k      /*add the element to the running total.*/
          prod=prod*y.k      /*multiple the element to running prod.*/
          end   /*k*/

say '    sum of'  m  "elements for the Y array is: "  sum
say 'product of'  m  "elements for the Y array is: "  prod
                             /*stick a fork in it, we're done.      */
