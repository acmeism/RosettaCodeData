/*REXX program displays which years  December 25th  falls on a  Sunday. */
parse arg start finish .               /*get the start and finish years.*/
if  start=='' then  start=2008         /*None specified?  Assume default*/
if finish=='' then finish=2121         /*None specified?  Assume default*/

      do y=start to finish             /*process the years specified.   */

      if date('Weekday',y"-12-25",'ISO')\=='Sunday' then iterate
   /* if date('w'      ,y"-12-25",'i'  )\== ...    (same as above).  */
   /*          option  yyyy-mm-dd  fmt                               */

      say 'December 25th,' y "falls on a Sunday."
      end  /*y*/
                                       /*stick a fork in it, we're done.*/
