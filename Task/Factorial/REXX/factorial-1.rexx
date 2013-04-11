/*REXX program computes the factorial of a non-negative integer.        */
numeric digits 100000                 /*100k digs:  handles N up to 25k.*/
parse arg n                           /*get argument from command line. */
if n=''                   then call er 'no argument specified'
if arg()>1 | words(n)>1   then call er 'too many arguments specified.'
if \datatype(n,'N')       then call er "argument isn't numeric: "        n
if \datatype(n,'W')       then call er "argument isn't a whole number: " n
if n<0                    then call er "argument can't be negative: "    n
!=1                                   /*define factorial product so far.*/

/*══════════════════════════════════════where da rubber meets da road──┐*/
     do j=2 to n;    !=!*j            /*compute  the ! the hard way◄───┘*/
     end   /*j*/
/*══════════════════════════════════════════════════════════════════════*/

say n'!  is  ['length(!) "digits]:"   /*display # of digits in factorial*/
say                                   /*add some whitespace to output.  */
say !/1                               /*normalize the factorial product.*/
exit                                  /*stick a fork in it, we're done. */
/*─────────────────────────────────ER subroutine────────────────────────*/
er:  say;   say '***error!***';   say;   say arg(1);   say;  say;  exit 13
