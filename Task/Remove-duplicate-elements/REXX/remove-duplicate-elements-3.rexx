/*REXX program to  remove  duplicate  elements  (items)  in a  list.    */
old= '2 3 5 7 11 13 17 19 cats 222 -100.2 +11 1.1 +7 7. 7 5 5 3 2 0 4.4 2'
say 'original list:'  old
say right(words(old),13) ' words in the original list.';    say
new=                                   /*start with a clean slate.      */

  do j=1 for words(old); _=word(old,j) /*process the words in old list. */
  if wordpos(_,new)==0  then new=new _ /*Doesn't exist? Then add to list*/
  end   /*j*/

say 'modified list:'   space(new)
say right(words(new),13) ' words in the modified list.'
                                       /*stick a fork in it, we're done.*/
