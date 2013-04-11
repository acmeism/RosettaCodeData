/*REXX program to simulate  7-sided  die  based  on a  5-sided throw.   */
parse arg trials sample .              /*get arguments from command line*/
if trials==''  then trials=1           /*Not specified? Then use default*/
if sample==''  then sample=1000000     /* "      "        "   "     "   */

  do t=1  for trials                   /*performe the number of trials. */
  die.=0;   k=0
                     do  until k==sample;    r=5*random(1,5)+random(1,5)-6
                     if r>20  then iterate
                     k=k+1;                  r=r//7+1;       die.r=die.r+1
                     end   /*until*/
  expect=sample%7
  say
  say center('trial:'right(t,4) '   ' sample 'samples, expect='expect,79,'─')
  say

     do j=1  for 7
     say '      side' j "had " die.j ' occurences',
         '      difference from expected:'right(die.j-expect,length(sample))
     end   /*j*/
  end      /*t*/
                                       /*stick a fork in it, we're done.*/
