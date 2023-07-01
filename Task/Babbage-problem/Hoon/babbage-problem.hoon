::  This is Hoon, a language for writing human-legible
::  instructions to a machine called Urbit.
::
::  A pair of non-alphanumeric symbols is called a rune.
::  Each rune begins a unique expression.
::
::  An expression can be an instruction to the machine,
::  or a description of essential information.
::  Each rune specifies a different expression.
::  Each expression can contain other expressions.
::  (In practice, every expression contains
::  at least one of the expressions that follow it.)
::
::  :: tells the machine to ignore the rest of a line
::     these lines allow commentary for a human reader
::     like the question this program will answer:
::
::  What is the smallest positive integer whose
::  square ends in the digits 269,696?
::
::  The program of instructions for solving this,
::  uninterrupted by commentary, is:
::
::  :-  %say
::  |=  [*]
::  :-  %noun
::  ^-  @ud
::  =/  n  0
::  |-
::  ?:  =(269.696 (mod (pow n 2) 1.000.000))
::    n
::  %=  $
::    n  +(n)
::  ==
::
::  The first three significant lines describe
::  two things: our program's input, and its structure.
::  They specify the program requires no input.
::  Otherwise, we can ignore them for our purposes.
::
::  ^-  describes the desired output of our program.
::  @ud signifies an unknown positive integer.
::      The output will be a positive integer.
::      The output will be our answer.
:-  %say
|=  [*]
:-  %noun
^-  @ud
::
::  =/ assigns a value to a name, for future reference.
::     Here we assign value 0 to "n", as in algebra.
=/  n  0
::
::  |- begins a recursive, iterative process.
::     It might not end until a condition is met.
|-
::
::  ?: does two things.
::     First, it returns a Boolean true-or-false answer
::     to the question that follows.
::     Second, it evaluates one of two expressions
::     branching on whether the answer is true or false.
::
::  Here we rephrase our question for the machine:
::  "Is 269,696 equal to the remainder of
::  n^2 divided by 1,000,000?"
?:  =(269.696 (mod (pow n 2) 1.000.000))
::
::  If so, we get our answer: the current value of n.
  n
::
::  If not, we run the whole program again,
::  but this time n is replaced by (n+1).
::  n will be incremented by 1 until our
::  ?: question has the answer "true",
::  upon which it will return n.
::  If n is 0, it will now be 1.
::  If n is 25,263, it will now be 25,264 which,
::  as this program shows, is the smallest positive
::  integer whose square ends in the digits 269,696.
::
::  %= runs the whole program again, but
::     with the listed names, on the left, assigned
::     new values on the right. It could take an
::     arbitrary number of children, so unlike the
::     other runes here which take a fixed number,
::     this expression must end in a == rune, which
::     just brings the expression to an end.
%=  $
  n  +(n)
==
