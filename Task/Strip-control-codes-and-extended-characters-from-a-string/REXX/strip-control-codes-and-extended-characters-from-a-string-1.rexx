/*REXX program strips all  "control codes"  from a character string  (ASCII or EBCDIC). */
z= 'string of ☺☻♥♦⌂, may include control characters and other    ♫☼§►↔◄░▒▓█┌┴┐±÷²¬└┬┘ilk.'
@=' !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~'
$=
   do j=1  for length(z);   _=substr(z, j, 1)    /*get a char from   X   one at a time. */
   if verify(_, @)==0  then $=$ || _             /*Is char in the @ list?   Then use it.*/
   end   /*j*/                                   /*stick a fork in it,  we're all done. */

say 'old = »»»'z"«««"                            /*add ««fence»» before & after old text*/
say 'new = »»»'$"«««"                            /* "      "        "   "   "   new   " */
