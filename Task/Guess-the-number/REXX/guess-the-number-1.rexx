#!/usr/bin/rexx
/*REXX program to play:    Guess the number  */

number = random(1,10)
say "I have thought of a number. Try to guess it!"

guess=0    /* We don't want a valid guess, before we start */

do while guess \= number
  pull guess
  if guess \= number then
    say "Sorry, the guess was wrong. Try again!"
  /* endif - There is no endif in rexx. */
end

say "Well done! You guessed it!"
