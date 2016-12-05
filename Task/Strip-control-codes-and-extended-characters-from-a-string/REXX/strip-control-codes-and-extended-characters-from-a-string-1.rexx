/*REXX program strips all  "control codes"  from a character string  (ASCII or EBCDIC). */
xxx= 'string of ☺☻♥♦⌂, may include control characters and other ilk.♫☼§►↔◄'
                                                 /*in EBCDIC,  the digit  1  is  'f1'x, */
                                                 /* "  ASCII,   "    "    "   "   31'x. */
ebcdic=  (1=='f1'x)                              /*is this an   EBCDIC   computer ?     */
                                                 /*generate a string of characters from */
                                                 /*'00'x ──►  [1 just before the blank].*/
ccChars = xrange(,d2c(c2d(' ') -1))              /*generate a  range  of characters.    */
if \ebcdic  then ccChars=ccChars'7f'x            /*add the ASCII   '7f'X   character.   */
say 'hex ccChars =' c2x(ccChars)                 /*might as well do a display of ccChars*/
ccCharsX = ccChars'ff'x                          /*add a  "stop"  character for ccCharsX*/

_stop= substr(ccCharsX,verify(ccCharsX, xxx), 1) /*find a  "stop"  character.           */
yyy  = translate(space(translate(xxx, _stop, " "ccChars), 0), , _stop)

say 'old = »»»'xxx"«««"                          /*add ««fence»» before & after old text*/
say 'new = »»»'yyy"«««"                          /* "      "        "   "   "   new   " */
                                                 /*stick a fork in it,  we're all done. */
