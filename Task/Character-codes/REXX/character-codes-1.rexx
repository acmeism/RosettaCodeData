yyy='c'               /*assign a lowercase   c to  YYY.*/
yyy='34'x             /*assign hexadecimal  34 to  YYY.*/
                      /*the  X  can be upper/lowercase.*/
yyy=x2c(34)           /* (same as above)               */
yyy='00110100'b       /* (same as above)               */
yyy='0011 0100'b      /* (same as above)               */
                      /*the  B  can be upper/lowercase.*/
yyy=d2c(97)           /*assign decimal code 97 to  YYY.*/

say yyy               /*displays the value of  YYY.                       */
say c2x(yyy)          /*displays the value of  YYY in hexadecimal.        */
say c2d(yyy)          /*displays the value of  YYY in decimal.            */
say x2b(c2x(yyy))     /*displays the value of YYY in binary (bit string). */
                      /*Note:  some REXXes support the    c2b    bif      */
