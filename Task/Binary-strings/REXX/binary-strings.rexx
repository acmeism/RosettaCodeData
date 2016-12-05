/*REXX program demonstrates methods (code examples)  to use and express  binary strings.*/
dingsta= '11110101'b                             /*four versions, bit string assignment.*/
dingsta= "11110101"b                             /*this is the same assignment as above.*/
dingsta= '11110101'B                             /*  "   "  "    "      "       "   "   */
dingsta= '1111 0101'B                            /*  "   "  "    "      "       "       */
dingsta2=dingsta                                 /*clone one string to another (a copy).*/
other= '1001 0101 1111 0111'b                    /*another binary  (or bit)  string.    */
if dingsta=other     then say 'they are equal'   /*compare the two  (binary)  strings.  */
if other==''         then say 'OTHER is empty.'  /*see if the   OTHER   string is empty.*/
otherA=other || '$'                              /*append a dollar sign ($)  to  OTHER. */
otherB=other'$'                                  /*same as above,  but with less fuss.  */
guts=substr(c2b(other), 10, 3)                   /*obtain the  10th  through  12th bits.*/
new=changeStr('A', other, "Z")                   /*change the upper  letter  A  ──►  Z. */
tt=changeStr('~~', other, ";")                   /*change two tildes ──►  one semicolon.*/
joined=dignsta || dingsta2                       /*join two strings together (concat).  */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
c2b:       return x2b( c2x( arg(1) ) )           /*return the string as a binary string.*/
