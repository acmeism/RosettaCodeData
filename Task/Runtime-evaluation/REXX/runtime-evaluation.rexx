/*REXX program to illustrate ability to execute code written at runtime.*/
numeric digits 10000000
bee=51
stuff='bee=min(-2,44); say 13*2 "[from inside the box."; abc=abs(bee)'
interpret stuff
say 'bee=' bee
say 'abc=' abc
say

say 'enter an expression:'
pull expression
say
say 'expression entered is:' expression

interpret '?='expression

say
say 'length of result='length(?)
say ' left 50 bytes of result='left(?,50)'...'
say 'right 50 bytes of result=...'right(?,50)

                                       /*stick a fork in it, we're done.*/
