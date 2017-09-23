/*REXX program demonstrates a    FOREVER   DO  loop  with a test to   LEAVE  (break).   */

    do forever                                   /*perform loop until da cows come home.*/
    a=random(19)                                 /*same as:    random(0, 19)            */
    call charout , right(a, 5)                   /*show   A   right─justified, column 1.*/
    if a==10  then leave                         /*is random #=10?  Then cows came home.*/
    b=random(19)                                 /*same as:    random(0, 19)            */
    say right(b, 5)                              /*show   B   right─justified, column 2.*/
    end   /*forever*/
                                                 /*stick a fork in it,  we're all done. */
