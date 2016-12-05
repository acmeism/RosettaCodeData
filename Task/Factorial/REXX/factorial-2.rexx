/*REXX program computes the factorial of a  non-negative integer, and it automatically  */
/*────────────────────── adjusts the number of decimal digits to accommodate the answer.*/
numeric digits 99                                /*99 digits initially,  then expanded. */
parse arg n                                      /*obtain optional argument from the CL.*/
if n=''                   then call er  'no argument specified'
if arg()>1 | words(n)>1   then call er  'too many arguments specified.'
if \datatype(n,'N')       then call er  "argument isn't numeric: "          n
if \datatype(n,'W')       then call er  "argument isn't a whole number: "   n
if n<0                    then call er  "argument can't be negative: "      n
!=1                                              /*define the factorial product (so far)*/
     do j=2 to n;    !=!*j                       /*compute  the factorial the hard way. */
     if pos(.,!)==0  then iterate                /*is the  !  in exponential notation?  */
     parse var ! 'E' digs                        /*extract exponent of the factorial,   */
     numeric digits  digs+digs%10                /*  ··· and increase it by ten percent.*/
     end   /*j*/                                 /* [↑]  where da rubber meets da road. */

say n'!  is  ['length(!) "digits]:"              /*display number of digits in factorial*/
say                                              /*add some whitespace to the output.   */
say !/1                                          /*normalize the factorial product.     */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
er:    say;      say '***error!***';      say;       say arg(1);      say;         exit 13
