/*REXX program removes any duplicate elements (items) that are in a list (using a list).*/
$= '2 3 5 7 11 13 17 19 cats 222 -100.2 +11 1.1 +7 7. 7 5 5 3 2 0 4.4 2'    /*item list.*/
say 'original list:'     $
say right( words($), 17, '─')    'words in the original list.'
#=words($)                                       /*process all the words in the list.   */
       do j=#  by -1  for #;     y=word($, j)                      /*get right-to-Left. */
       _=wordpos(y, $, j + 1);   if _\==0  then $=delword($,_,1)   /*Dup? Then delete it*/
       end   /*j*/
say
say 'modified list:' space($)
say right( words(z), 17, '─')    'words in the modified list.'
                                                 /*stick a fork in it,  we're all done. */
