/*REXX program to  remove  duplicate  elements  (items)  in a  list.    */
$= '2 3 5 7 11 13 17 19 cats 222 -100.2 +11 1.1 +7 7. 7 5 5 3 2 0 4.4 2'
say 'original list:'     $
say right(words($),13) ' words in the original list.';    say

  do j=words($)  by -1  to 1; y=word($,j)  /*process words in the list, */
  _=wordpos(y, $, j+1);  if _\==0  then $=delword($, _, 1) /*del if dup.*/
  end   /*j*/

say 'modified list:'     space($)
say right(words($),13) ' words in the modified list.'
                                       /*stick a fork in it, we're done.*/
