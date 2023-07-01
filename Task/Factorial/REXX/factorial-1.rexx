/*REXX pgm computes & shows the factorial of a non─negative integer, and also its length*/
numeric digits 100000                            /*100k digits:  handles  N  up to  25k.*/
parse arg n                                      /*obtain optional argument from the CL.*/
if n=''                   then call er  'no argument specified.'
if arg()>1 | words(n)>1   then call er  'too many arguments specified.'
if \datatype(n,'N')       then call er  "argument isn't numeric: "          n
if \datatype(n,'W')       then call er  "argument isn't a whole number: "   n
if n<0                    then call er  "argument can't be negative: "      n
!= 1                                             /*define the factorial product (so far)*/
      do j=2  to n;       !=!*j                  /*compute the factorial the hard way.  */
      end   /*j*/                                /* [↑]  where da rubber meets da road. */

say n'!  is  ['length(!) "digits]:"              /*display number of digits in factorial*/
say                                              /*add some whitespace to the output.   */
say !                                            /*display the factorial product──►term.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
er:    say;       say '***error***';      say;      say arg(1);      say;          exit 13
