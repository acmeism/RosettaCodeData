/*REXX program checks to see if an entered string (sentence) is a pangram.    */
@abc = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'    /*a list of all (Latin) capital letters*/

  do forever;    say                   /*keep promoting 'til null (or blanks).*/
  say '───── Please enter a pangramic sentence:';       say
  pull y                               /*this also uppercases the  Y variable.*/
  if y=''  then leave                  /*if nothing entered,  then we're done.*/
  ?=verify(@abc,y)                     /*Are all the (Latin) letters present? */

  if ?==0  then say 'Sentence is a pangram.'
           else say "Sentence isn't a pangram, missing:"  substr(@abc,?,1)
  say
  end   /*forever*/

say '───── PANGRAM program ended. ─────'
                                       /*stick a fork in it,  we're all done. */
