/*REXX program removes any duplicate elements (items) that are in a list (using a hash).*/
$= '2 3 5 7 11 13 17 19 cats 222 -100.2 +11 1.1 +7 7. 7 5 5 3 2 0 4.4 2'    /*item list.*/
say 'original list:'     $
say right( words($), 17, '─')    'words in the original list.'
z=;                              @.=             /*initialize the NEW list & index list.*/
     do j=1  for words($);       y=word($,j)     /*process the words (items) in the list*/
     if @.y==''  then z=z y;     @.y=.           /*Not duplicated? Add to Z list,@ array*/
     end   /*j*/
say
say 'modified list:'   space(z)
say right( words(z), 17, '─')    'words in the modified list.'
                                                 /*stick a fork in it,  we're all done. */
