/*REXX program computes the factorial of a non-negative integer,  and   */
/* automatically adjusts the number of digits to accommodate the answer.*/
/* ┌────────────────────────────────────────────────────────────────┐
   │               ───── Some factorial lengths ─────               │
   │                                                                │
   │                   10 !  =           7  digits                  │
   │                   20 !  =          19  digits                  │
   │                   52 !  =          68  digits                  │
   │                  104 !  =         167  digits                  │
   │                  208 !  =         394  digits                  │
   │                  416 !  =         394  digits   (8 deck shoe)  │
   │                                                                │
   │                   1k !  =       2,568  digits                  │
   │                  10k !  =      35,660  digits                  │
   │                 100k !  =     456,574  digits                  │
   │                                                                │
   │                   1m !  =   5,565,709  digits                  │
   │                  10m !  =  65,657,060  digits                  │
   │                 100m !  = 756,570,556  digits                  │
   │                                                                │
   │  Only one result is shown below for pratical reasons.          │
   │                                                                │
   │  This version of the REXX interpreter is essentially limited   │
   │  to around  8  million digits,  but with some programming      │
   │  tricks,  it could yield a result up to  ≈ 16  million digits. │
   │                                                                │
   │  Also, the Regina REXX interpreter is limited to an exponent   │
   │   9  digits,    i.e.:       9.999...999e+999999999             │
   └────────────────────────────────────────────────────────────────┘   */
numeric digits 99                     /*99 digs initially, then expanded*/
numeric form                          /*exponentiated #s =scientric form*/
parse arg n                           /*get argument from command line. */
if n=''                   then call er 'no argument specified'
if arg()>1 | words(n)>1   then call er 'too many arguments specified.'
if \datatype(n,'N')       then call er "argument isn't numeric: "        n
if \datatype(n,'W')       then call er "argument isn't a whole number: " n
if n<0                    then call er "argument can't be negative: "    n
!=1                                   /*define factorial product so far.*/

/*══════════════════════════════════════where da rubber meets da road──┐*/
     do j=2 to n;    !=!*j            /*compute  the ! the hard way◄───┘*/
     if pos('E',!)==0  then iterate   /*is  !  in exponential notation? */
     parse var ! 'E' digs             /*pick off the factorial exponent.*/
     numeric digits  digs+digs%10     /*  and incease it by ten percent.*/
     end   /*j*/
/*══════════════════════════════════════════════════════════════════════*/

say n'!  is  ['length(!) "digits]:"   /*display # of digits in factorial*/
say                                   /*add some whitespace to output.  */
say !/1                               /*normalize the factorial product.*/
exit                                  /*stick a fork in it, we're done. */
/*─────────────────────────────────ER subroutine────────────────────────*/
er:  say;   say '***error!***';   say;   say arg(1);   say;  say;  exit 13
