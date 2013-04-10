/*REXX program (old school) displays which years 12/25 falls on a Sunday*//

parse arg start finish .               /*get the start and finish years.*/
if  start=='' then  start=2008         /*None specified?  Assume default*/
if finish=='' then finish=2121         /*None specified?  Assume default*/

      do y=start to finish             /*process the years specified.   */
      if dow(12,25,y)==1 then say 'December 25th,' y "falls on a Sunday."
      end   /*y*/
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────────────DOW (day of week) subroutine─────*/
dow: procedure;  arg m,d,y;    if m<3 then    do;   m=m+12;   y=y-1;   end
yL=left(y,2);  yr=right(y,2);  w=(d + (m+1)*26%10+yr+yr%4+yL%4+5*yL) // 7
if w==0 then w=7;   return w     /*Sunday=1,  Monday=2,  ...  Saturday=7*/
