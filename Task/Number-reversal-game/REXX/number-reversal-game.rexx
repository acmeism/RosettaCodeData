/*REXX pgm (a game): reverse a jumbled set of numerals until they're in order.*/
signal on halt                         /*allows the CBLF to  HALT the program.*/
___=copies('─',9)                      /*a fence used for computer's messages.*/
say ___ "This game will show you nine random unique digits  (1 ──► 9),   and you'll"
say ___ "enter one of those digits  which will reverse all the digits up to  (and"
say ___ "including)  that digit.      The game's objective is to get all the"
say ___ "digits in ascending order with the fewest tries.     Here are your digits:"
ok=123456789                           /*the result that the string should be.*/
$=
      do  until length($)==9           /*build a random unique numeric string.*/
      _=random(1,9);  if pos(_,$)\==0  then iterate     /*only use a dig once.*/
      $=$ || _                                          /*construct a string. */
      if $==ok  then $=                /*string can't be in order, start over.*/
      end   /*until ··· */

  do  score=1  until  $==ok            /* [↓]  display the digs and the prompt*/
  say;         say ___  $   right('please enter a digit  (or  Quit):', 50)
  pull x .;  ?=left(x,1)               /*get a decimal digit (maybe) from CBLF*/
  if abbrev('QUIT',x,1)  then signal halt
  if length(x)>1  then do;  say ___  'oops, invalid input!  '  x;  iterate;  end
  if x==''  then  iterate              /*try again, CBLF didn't enter anything*/
  g=pos(?,$)                           /*validate if the input digit is legal.*/
  if g==0  then say   ___  'oops, invalid digit!  '   ?
           else $=reverse(left($, g))substr($, g+1)
  end   /*score*/

say;     say ___  $;     say;    say center(' Congratulations! ',70,"═");    say
say ___ 'Your score was' score;  exit  /*stick a fork in it,  we're all done. */
halt:  say  ___   'quitting.';   exit  /*  "   "   "   "  "     "    "    "   */
