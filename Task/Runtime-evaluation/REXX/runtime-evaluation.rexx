/*REXX program illustrates the ability to  execute code  entered  at runtime (from C.L.)*/
numeric digits 10000000                          /*ten million digits should do it.     */
bee=51
stuff= 'bee=min(-2,44);  say 13*2 "[from inside the box.]";  abc=abs(bee)'
interpret stuff
say 'bee='  bee
say 'abc='  abc
say
                                                 /* [↓]  now, we hear from the user.    */
say 'enter an expression:'
pull expression
say
say 'expression entered is:'  expression
say

interpret '?='expression

say 'length of result='length(?)
say ' left 50 bytes of result='left(?,50)"···"
say 'right 50 bytes of result=···'right(?, 50)   /*stick a fork in it,  we're all done. */
