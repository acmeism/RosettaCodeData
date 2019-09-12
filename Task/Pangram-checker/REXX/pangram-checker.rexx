/*REXX program  verifies  if an  entered/supplied  string  (sentence)  is a pangram.    */
@abc= 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'               /*a list of all (Latin) capital letters*/

    do forever;    say                           /*keep promoting 'til null (or blanks).*/
    say '──────── Please enter a pangramic sentence   (or a blank to quit):';      say
    pull y                                       /*this also uppercases the  Y variable.*/
    if y=''  then leave                          /*if nothing entered,  then we're done.*/
    absent= space( translate( @abc, , y), 0)     /*obtain a list of any absent letters. */
    if absent==''  then say  "──────── Sentence is a pangram."
                   else say  "──────── Sentence isn't a pangram, missing: "    absent
    say
    end   /*forever*/

say '──────── PANGRAM program ended. ────────'   /*stick a fork in it,  we're all done. */
