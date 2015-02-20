/*REXX pgm plays  guess-the-number  (with itself) with positive integers*/
numeric digits 9                       /*this is the normal REXX default*/
parse arg low high .,guess             /*get optional args from the C.L.*/
if  low==''  then  low=1               /*Not given? Then use the default*/
if high==''  then high=1000            /* "    "      "   "   "     "   */
?=random(low,high)                     /*get a random (non-negative) int*/
$="Try to guess my integer  (it's between"  low  'and'  high" inclusive)."

     do try=1;     say $;     say;     oguess=guess    /*save old guess.*/
     if pos('high',info)\==0  then high=guess    /*test if its too high.*/
     if pos('low' ,info)\==0  then low =guess    /*  "   "  "   "  low. */
     guess=low+(high-low)%2                      /*calculate next guess.*/
     if guess=oguess          then guess=guess+1 /*bump the # of guesses*/
     say 'My guess is'  guess                    /*display comp's guess.*/

                        select
                        when guess>?  then info=right("It's too high.",40)
                        when guess<?  then info=right("It's too low. ",40)
                        otherwise leave          /*leave the TRY do loop*/
                        end   /*select*/
     end   /*try*/
say
say 'Congratulations!   You guessed the secret number in'   try   "tries."
                                       /*stick a fork in it, we're done.*/
