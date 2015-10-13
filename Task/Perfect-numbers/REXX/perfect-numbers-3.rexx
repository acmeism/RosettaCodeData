/*REXX program tests if a number (or a range of numbers) is/are perfect.*/
parse arg low high .                   /*obtain the specified number(s).*/
if high=='' & low==''  then high=34000000     /*if no args, use a range.*/
if  low==''            then  low=1     /*if no   LOW, then assume unity.*/
if high==''            then high=low   /*if no  HIGH, then assume  LOW. */
w=length(high)                         /*use  W  for formatting output. */
numeric digits max(9,w+2)              /*ensure enough digits to handle#*/

               do i=low  to high       /*process the single # or range. */
               if isPerfect(i)  then say right(i,w) 'is a perfect number.'
               end   /*i*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────ISPERFECT subroutine────────────────*/
isPerfect: procedure;  parse arg x     /*get the number to be tested.   */
if x<6  then return 0                  /*perfect numbers can't be < six.*/
s=1                                    /*the first factor of  X.       _*/
             do j=2  while  j*j<=x     /*starting at 2, find factors ≤√X*/
             if x//j\==0  then iterate /*J isn't a factor of X, so skip.*/
             s = s + j + x%j           /*··· add it and the other factor*/
             if s>x  then return 0     /*Sum too big?  It ain't perfect.*/
             end   /*j*/               /*(above)  is marginally faster. */
return s==x                            /*if the sum matches X, perfect! */
