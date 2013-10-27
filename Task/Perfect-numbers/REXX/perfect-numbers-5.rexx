/*REXX program tests if a number (or a range of numbers) is/are perfect.*/
parse arg low high .                   /*obtain the specified number(s).*/
if high=='' & low==''  then high=34000000     /*if no args, use a range.*/
if  low==''            then  low=1     /*if no   LOW, then assume unity.*/
if high==''            then high=low   /*if no  HIGH, then assume  LOW. */
w=length(high)                         /*use  W  for formatting output. */
numeric digits max(9,w+2)              /*ensure enough digits to handle#*/

               do i=low  to high       /*process the single # or range. */
               if isperfect(i)  then say right(i,w) 'is a perfect number.'
               end   /*i*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────ISPERFECT subroutine────────────────*/
isperfect: procedure;  parse arg x 1 y /*get the number to be tested.   */
if x//2  then return 0                 /*handle special cases of odd #s.*/
if x==6  then return 1                 /*handle special case  of  six.  */
if x<28  then return 0                 /*now, perfect numbers must be>27*/

      do  until  length(y)==1          /*find the digital root of  Y.   */
      parse var y 1 r 2;  do k=2 for length(y)-1;  r=r+substr(y,k,1);  end
      y=r                              /*find digital root of dig root. */
      end   /*DO until*/               /*wash, rinse, repeat ···        */

if r\==1  then return 0                /*is dig root ¬1?  Then ¬perfect.*/
s = 3 + x%2                            /*the first three factors of  X. */
             do j=3  while j*j<=x      /*starting at 3, find factors ≤√X*/
             if x//j\==0  then iterate /*J isn't a factor of X, so skip.*/
             s = s + j + x%j           /*··· add it and the other factor*/
             if s>x  then return 0     /*Sum too big?  It ain't perfect.*/
             end   /*j*/               /*(above)  is marginally faster. */
return s==x                            /*if the sum matches X, perfect! */
