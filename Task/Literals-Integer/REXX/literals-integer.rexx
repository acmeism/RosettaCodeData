/*REXX pgm displays an  integer  (expressed in the pgm as a literal)  in different bases*/
                                      /*────────── expressing decimal numbers ──────────*/
ddd =  123                            /*a decimal number  (expressed as a literal).     */
ddd = '123'                           /*this is exactly the same as above.              */
ddd = "123"                           /*this is exactly the same as above also.         */
                                      /*────────── expressing hexadecimal numbers ──────*/
hhh = '7b'x                           /*a value,  expressed as a hexadecimal literal.   */
hhh = '7B'x                           /* (same as above)  using a capital  "B".         */
hhh = '7B'X                           /* (same as above)  using a capital  "X".         */
cow = 'dead beef'x                    /*another value,    with a blank for the eyeballs.*/
cow = 'de ad be ef'x                  /* (same as above)  with  blanks for the eyeballs.*/
                                      /*────────── expressing binary numbers ───────────*/
bbb =  '1111011'b                     /*a value,  expressed as a binary literal.        */
bbb = '01111011'b                     /* (same as above)  with a full 8 binary digits.  */
bbb = '0111 1011'b                    /* (same as above)  with a blank for the eyeballs.*/

say '    base  10='            ddd
say '    base   2='  x2b( d2x( ddd ) )
say '    base  16='       d2x( ddd )
say '    base 256='       d2c( ddd )  /*the output displayed is ASCII (or maybe EBCDIC).*/

thingy1=  +123                        /*╔══════════════════════════════════════════════╗*/
thingy2= '+123'                       /*║ All of the THINGYs variables aren't strictly ║*/
thingy3= ' 123'                       /*║ (exactly)  equal to the  DDD  variable,  but ║*/
thingy4=   123.                       /*║ they do compare numerically equal.   When    ║*/
thingy5=    12.3e+1                   /*║ compared numerically, numbers are rounded to ║*/
thingy6=  1230e-1                     /*║ the current setting of  NUMERIC DIGITS.  The ║*/
thingy7=  1230E-0001                  /*║ default for  (decimal)  NUMERIC DIGITS is  9 ║*/
thingy8= ' +     123  '               /*╚══════════════════════════════════════════════╝*/

                                                 /*stick a fork in it,  we're all done. */
