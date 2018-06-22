/*REXX program (a game):  reverse a jumbled set of decimal digits 'til they're in order.*/
signal on halt                                   /*allows the CBLF to  HALT the program.*/
___= copies('─', 9);      pad=left('', 9)        /*a fence used for computer's messages.*/
say ___  "This game will show you nine random unique digits  (1 ──► 9),  and you'll enter"
say ___  "one of those digits  which will reverse all the digits from the left-most digit"
say ___  "up to  (and including)  that decimal digit.  The game's objective is to get all"
say ___  "of the digits in ascending order with the fewest tries.    Here're your digits:"
ok= 123456789                                    /*the result that the string should be.*/
$=                                               /* ◄─── decimal target to be generated.*/
      do  until length($)==9;     _=random(1, 9) /*build a random unique numeric string.*/
      if pos(_, $) \== 0  then iterate           /*¬ unique? Only use a decimal dig once*/
      $=$ || _                                   /*construct a string of unique digits. */
      if $==ok  then $=                          /*string can't be in order, start over.*/
      end   /*until*/

  do  score=1  until  $==ok;           say       /* [↓]  display the digits & the prompt*/
  say ___  $   right('please enter a digit  (or  Quit):', 50)
  parse pull ox  .  1  ux . 1  x  .;   upper ux  /*get a decimal digit (maybe) from CBLF*/
  if abbrev('QUIT', ux, 1)  then signal halt     /*does the CBLF want to quit this game?*/
  if length(x)>1  then do;  say ___ pad '***error***  invalid input:  ' ox;  iterate;  end
  if x=''  then  iterate                         /*try again, CBLF didn't enter anything*/
  g=pos(x, $)                                    /*validate if the input digit is legal.*/
  if g==0  then say ___ pad '***error***  invalid digit:  '     ox
           else $=strip(reverse(left($,g))substr($,g+1))  /*reverse some (or all) digits*/
  end   /*score*/

say;    say ___  $;     say;    say center(' Congratulations! ', 70, "═");       say
say ___ pad  'Your score was' score;  exit       /*stick a fork in it,  we're all done. */
halt:  say  ___  pad  'quitting.';     exit      /*  "   "   "   "  "     "    "    "   */
