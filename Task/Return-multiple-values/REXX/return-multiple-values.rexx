/*REXX program shows examples of multiple RETURN values from a function.*/
numeric digits 70                      /*default is:   NUMERIC DIGITS 9 */
arg a b                                /*get 2 numbers from comand line.*/
say ' a =' a                           /*display the first number.      */
say ' b =' b                           /*   "     "  second   "         */
say copies('=',50)                     /*display a separator line.      */

z=giveMeBackStuff(a,b)                 /*call function: giveMeBackStuff */

parse var z sum dif mod div idiv prod pow     /*get the returned values,*/
                           prod=word(z,6)     /*obtain an alternate way.*/
say ' + ='  sum
say ' - ='  dif
say '// ='  mod
say ' / ='  div
say ' % ='  idiv
say ' * ='  prod
say '** ='  pow
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────giveMeBackStuff subroutine──────────*/
giveMeBackStuff:  procedure;    parse arg x,y
      addition = x+y
      subtract = x-y
      modulus  = x//y
      divide   = x/y
      intDiv   = x%y
      multiply = x*y
      power    = x**y
return  addition  subtract  modulus  divide  intDiv  multiply  power
/*──────────────────────────────────giveMeBackStuff2 subroutine─────────*/
giveMeBackStuff2:  procedure;    parse arg x,y
return  x+y  x-y  x//y  x/y  x%y  x*y  x**y     /*same as version above.*/
