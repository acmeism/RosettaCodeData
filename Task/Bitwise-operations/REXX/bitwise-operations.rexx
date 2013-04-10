/*REXX program performs bitwise operations on integers:  & | && ¬ «L »R */
numeric digits 1000                    /*be able to handle bit integers.*/

say  center('decimal',9)   center("value",9)     center('bits',50)
say  copies('─',9)         copies('─',9)         copies('─',50)

a = 21  ;      call show  a            ,  'A'          /* show & tell A */
b =  3  ;      call show  b            ,  'B'          /* show & tell B */

               call show  bAnd(a,b)    ,  'A & B'      /*  and          */
               call show  bOr( a,b)    ,  'A | B'      /*   or          */
               call show  bXOr(a,b)    ,  'A && B'     /*  xor          */
               call show  bNot(a)      ,  '¬ A'        /*  not          */
               call show  bShiftL(a,b) ,  'A [«B]'     /* shift  left   */
               call show  bShiftR(a,b) ,  'A [»B]'     /* shirt right   */

     /*┌───────────────────────────────────────────────────────────────┐
       │ Since REXX stores numbers (indeed, all values) as characters, │
       │ it makes no sense to "rotate" a value, since there aren't any │
       │ boundries for the value.   I.E.:  there isn't any 32─bit word │
       │ "container"  or  "cell"  (for instance)  to store an integer. │
       └───────────────────────────────────────────────────────────────┘*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────subroutines─────────────────────────*/
show:    procedure; parse arg x,t; say right(x,9) center(t,9) right(d2b(x),50);  return
d2b:     return x2b(d2x(arg(1))) +0    /*some REXXes have the  D2B  bif.*/
b2d:     return x2d(b2x(arg(1)))       /*some REXXes have the  B2D  bif.*/
bNot:    return b2d(translate(d2b(arg(1)), 10, 01)) +0   /*+0≡normalize.*/
bShiftL: return (b2d(d2b(arg(1)) || copies(0, arg(2)))) +0
bAnd:    procedure; parse arg x,y;  return c2d(bitand(d2c(x), d2c(y)))
bOr:     procedure; parse arg x,y;  return c2d(bitor( d2c(x), d2c(y)))
bXor:    procedure; parse arg x,y;  return c2d(bitxor(d2c(x), d2c(y)))

bShiftR: procedure; parse arg x,y;  $=substr(reverse(d2b(x)), y+1)
         if $==''  then $=0;        return b2d(reverse($))
