/*REXX pgm to play guess-the-number (with itself) with positive integers*/
parse arg low high .
if  low=='' then  low=1
if high=='' then high=1000
?=random(low,high)
say
try="Try to guess my integer  (it's between" low 'and' high" inclusive)."

        do j=1
        say try;         say
        call guesser
                         select
                         when guess>? then info=right("It's too high.",40)
                         when guess<? then info=right("It's too low. ",40)
                         otherwise leave
                         end   /*select*/
        end   /*j*/
say
say 'Congratulations!  You guessed the secret number in' j "tries."
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────GUESSER subroutine──────────────────*/
guesser: oguess=guess
if pos('high',info)\==0  then high=guess
if pos('low' ,info)\==0  then low =guess
guess=low+(high-low)%2
if guess=oguess          then guess=guess+1
say 'My guess is' guess
return
