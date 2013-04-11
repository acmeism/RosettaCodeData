/*REXX program to check if an entered string (sentence) is a pangram.   */
abc='ABCDEFGHIJKLMNOPQRSTUVWXYZ'

  do forever                 /*keep prompting until a null or blank(s). */
  say;     say '───── Please enter a pangramic sentence:';     say
  pull y                     /*this also uppercases the  Y  variable.   */
  if y='' then leave         /*if nothing entered, then we're done.     */
  ?=verify(abc,y)            /*see if all (Latin) letters are present.  */

  if ?==0 then say 'Sentence is a pangram.'
          else say "Sentence isn't a pangram, missing:" substr(abc,?,1)
  say
  end   /*forever*/

say '───── PANGRAM program ended. ─────'
                                       /*stick a fork in it, we're done.*/
