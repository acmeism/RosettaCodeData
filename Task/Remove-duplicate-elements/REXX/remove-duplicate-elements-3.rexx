/*REXX program removes any duplicate elements (items) that are in a list (using 2 lists)*/
old = '2 3 5 7 11 13 17 19 cats 222 -100.2 +11 1.1 +7 7. 7 5 5 3 2 0 4.4 2'
say 'original list:'   old
say right( words(old), 17, '─')    'words in the original list.'
new=                                             /*start with a clean  (list)  slate.   */
     do j=1  for words(old);     _= word(old, j) /*process the words in the  OLD  list. */
     if wordpos(_, new)==0  then new= new _      /*Doesn't exist?  Then add word to NEW.*/
     end   /*j*/
say
say 'modified list:'     space(new)              /*stick a fork in it,  we're all done. */
say right( words(new), 17, '─')    'words in the modified list.'
