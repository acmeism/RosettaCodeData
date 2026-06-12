/*REXX program  implements and displays a  Sattolo shuffle  for an array  (of any type).*/
parse arg a;    say 'original:'      space(a)    /*obtain args from the CL; display 'em.*/
  do x=0  for words(a);  @.x= word(a, x+1);  end /*assign all elements to the @. array. */
                                                 /* [↑]  build an array of given items. */
       do #=x-1  by -1  to 1;  j= random(0, #-1) /*get a random integer between 0 & #-1.*/
       parse value @.#  @.j    with    @.j  @.#  /*swap two array elements, J is random.*/
       end   /*j*/                               /* [↑]  shuffle @ via Sattolo algorithm*/
$=                                               /* [↓]  build a list of shuffled items.*/
       do k=0  for x;   $= $  @.k;   end  /*k*/  /*append the next element in the array.*/
say  ' Sattolo:'        strip($)                 /*stick a fork in it,  we're all done. */
