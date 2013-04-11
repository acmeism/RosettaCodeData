abc = "abcdefghijklmnopqrstuvwxyz"    /*define all the lowercase letters*/
abcU = translate(abc)                 /*   "    "   "  uppercase    "   */

x = 'alphaBETA'                       /*define string to a REXX variable*/
y = translate(x)                      /*uppercase  X  and store it───► Y*/
z = translate(x, abc, abcU)           /*tran uppercase──►lowercase chars*/
