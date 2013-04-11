/*REXX program game:  reverse a jumbled set of numerals  until in order.*/

say "This game will show you nine random unique digits (1 ──► 9 inclusive),  and"
say "you'll enter one of those digits  which will reverse the digits up to  (and"
say "including)  that digit.    The game's objective is to get all the digits in"
say "ascending order with the fewest tries.    Here're your digits:";  say
$=''
      do  until length($)==9           /*generate random numeric string.*/
      _=random(1,9);   if pos(_,$)\==0 then iterate        /*no repeats.*/
      $=$ || _
      end   /*until*/

  do score=1  until $==123456789       /*keep truckin' until all ordered*/
  say $ left('',30) 'please enter a digit:'    /*issue a prompt to user.*/
  parse pull ? 2 .                     /*get one digit from the gamer.  */
  g=pos(?,$)                           /*full validation of input digit.*/
  if g==0  then say  'oops, invalid digit!' ?
           else $=reverse(left($,g))substr($,g+1)
  end   /*score*/

say center(' Congratulations! ',79,"═");      say  'Your score was'  score
                                       /*stick a fork in it, we're done.*/
