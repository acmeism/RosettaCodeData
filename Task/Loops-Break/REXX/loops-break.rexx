/*REXX program demonstrates a  FOREVER  DO  loop with a test to  LEAVE. */

      do forever                       /*perform until da cows come home*/
      a=random(19)                     /*same as:    random(0,19)       */
      call charout ,right(a,5)         /*show A right-justified, col. 1.*/
      if a==10  then leave             /*Random#=10? Then cows went home*/
      b=random(19)                     /*same as:    random(0,19)       */
      say right(b,5)                   /*show B right-justified, col. 2.*/
      end   /*forever*/
                                       /*stick a fork in it, we're done.*/
