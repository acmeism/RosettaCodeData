/*REXX pgm tests a number and a range for hailstone (Collatz) sequences.*/
parse arg x .;  if x=='' then x=27     /*get the optional first argument*/

$=hailstone(x)                         /*═════════════task 2════════════*/
#=words($)                             /*number of numbers in sequence. */
say x 'has a hailstone sequence of'  #  'and starts with: ' subword($,1,4),
                                       ' and ends with:'    subword($,#-3)
say
w=0;       do j=1  for 99999           /*═════════════task 3════════════*/
           $=hailstone(j);  #=words($) /*obtain the hailstone sequence. */
           if #<=w  then iterate       /*Not big 'nuff? Then keep going.*/
           bigJ=j;    w=#              /*remember what # has biggest HS.*/
           end   /*j*/

say '(between 1──►99,999) '  bigJ  'has the longest hailstone sequence:' w
                                       /*stick a fork in it, we're done.*/
