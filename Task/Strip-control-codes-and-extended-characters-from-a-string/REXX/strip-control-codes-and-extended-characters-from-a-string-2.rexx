/*REXX program strips all  "control codes"  from a character string  (ASCII or EBCDIC). */
xxx= 'string of ☺☻♥♦⌂, may include control characters and other ilk.♫☼§►↔◄'
                                                 /*in EBCDIC,  the digit  1  is  'f1'x, */
                                                 /* "  ASCII,   "    "    "   "   31'x. */
ascii=  ('31'x==1)                               /*is this an   ASCII   computer?       */
                                                 /*generate a string of characters from */
                                                 /*'00'x ──►  [1 just before the blank].*/
ccChars = xrange(, d2c(c2d(' ') -1) )            /*generate a  range  of characters.    */
if ascii  then ccChars=ccChars'7f'x              /*add the  ASCII   '7f'X   character.  */
say 'hex ccChars =' c2x(ccChars)                 /*might as well do a display of ccChars*/
yyy=                                             /*start with a clean slate.            */
         do j=1  for length(xxx)                 /*build a new string, 1 byte at a time.*/
         _=substr(xxx, j, 1)                     /*get next character in the old string.*/
         if pos(_, ccChars)\==0  then iterate    /*skip this character,  it's a no-no.  */
         yyy = yyy || _                          /*we found a good and decent character.*/
         end

say 'old = »»»'xxx"«««"                          /*add ««fence»» before & after old text*/
say 'new = »»»'yyy"«««"                          /* "      "        "   "   "   new   " */
                                                 /*stick a fork in it,  we're all done. */
