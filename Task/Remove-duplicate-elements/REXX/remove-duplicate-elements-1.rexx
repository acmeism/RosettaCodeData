/*REXX program removes any  duplicate  elements  (items)  that are in a list. */
$= '2 3 5 7 11 13 17 19 cats 222 -100.2 +11 1.1 +7 7. 7 5 5 3 2 0 4.4 2'
say 'original list:'     $
say right(words($),17,'─')  'words in the original list.';          say
z=;                             @.=   /*initialize the NEW list and index list*/
   do j=1  for words($); y=word($,j)  /*process the words (items) in the list.*/
   if @.y==''  then z=z y;      @.y=. /*Not duplicated? Add to Z list, @ array*/
   end   /*j*/

say 'modified list:'     space(z)
say right(words(z),17,'─')  'words in the modified list.'
                                       /*stick a fork in it,  we're all done. */
