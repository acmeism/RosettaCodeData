/*REXX program displays a char's ASCII code/value (or EBCDIC if run on an EBCDIC system)*/
yyy= 'c'                               /*assign a lowercase       c        to   YYY.    */
yyy= "c"                               /* (same as above)                               */
say  'from char, yyy code=' yyy

yyy= '63'x                             /*assign hexadecimal      63        to   YYY.    */
yyy= '63'X                             /* (same as above)                               */
say  'from  hex, yyy code=' yyy

yyy= x2c(63)                           /*assign hexadecimal      63        to   YYY.    */
say  'from  hex, yyy code=' yyy

yyy= '01100011'b                       /*assign a binary      0011 0100    to   YYY.    */
yyy= '0110 0011'b                      /* (same as above)                               */
yyy= '0110 0011'B                      /*   "   "    "                                  */
say  'from  bin, yyy code=' yyy

yyy= d2c(99)                           /*assign decimal code     99        to   YYY.    */
say  'from  dec, yyy code=' yyy

say                                    /*     [↓]    displays the value of  YYY  in ··· */
say  'char code: '   yyy               /* character code  (as an 8-bit ASCII character).*/
say  ' hex code: '   c2x(yyy)          /*    hexadecimal                                */
say  ' dec code: '   c2d(yyy)          /*        decimal                                */
say  ' bin code: '   x2b( c2x(yyy) )   /*         binary  (as a bit string)             */
                                       /*stick a fork in it, we're all done with display*/
