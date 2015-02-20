/*REXX version of the PL/I program (code was modified for Classic REXX).*/
parse arg low high .                   /*obtain the specified number(s).*/
if high=='' & low==''  then high=34000000     /*if no args, use a range.*/
if  low==''            then  low=1     /*if no   LOW, then assume unity.*/
if high==''            then high=low   /*if no  HIGH, then assume  LOW. */

               do i=low  to high       /*process the single # or range. */
               if perfect(i)  then say  i  'is a perfect number.'
               end   /*i*/
exit

perfect: procedure;  parse arg n       /*get the number to be tested.   */
sum=0                                  /*the sum of the factors so far. */
             do i=1  for n-1           /*starting at 1, find all factors*/
             if n//i==0 then sum=sum+i /*I is a factor of N,  so add it.*/
             end   /*i*/
return sum=n                           /*if the sum matches N, perfect! */
