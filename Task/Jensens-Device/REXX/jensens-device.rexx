/*REXX program to demonstrate Jensen's device  (call sub, arg by name). */
numeric digits 50                      /*might as well get some accuracy*/

say sum( 'i',  "1",  '100',  "1/i" )   /*invoke SUM (100th harmonic num)*/

exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SUM subroutine──────────────────────*/
sum:  procedure;   parse arg i,start,finish,term;    sum=0
interpret  'do'  i  "="  start  'to'  finish";    sum=sum+" term ';   end'
return sum
