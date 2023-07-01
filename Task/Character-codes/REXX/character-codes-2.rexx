/* REXX */
yyy='c'               /*assign a lowercase   c to  YYY */
yyy='83'x             /*assign hexadecimal  83 to  YYY */
                      /*the  X  can be upper/lowercase.*/
yyy=x2c(83)           /* (same as above)               */
yyy='10000011'b       /* (same as above)               */
yyy='1000 0011'b      /* (same as above)               */
                      /*the  B  can be upper/lowercase.*/
yyy=d2c(129)          /*assign decimal code 129 to YYY */

say yyy               /*displays the value of  YYY                   */
say c2x(yyy)          /*displays the value of  YYY in hexadecimal.   */
say c2d(yyy)          /*displays the value of  YYY in decimal.       */
say x2b(c2x(yyy))/*displays the value of YYY in binary (bit string). */
