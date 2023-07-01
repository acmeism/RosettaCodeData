/*REXX program strips all  "control codes"  from a character string  (ASCII or EBCDIC). */
x= 'string of ☺☻♥♦⌂, may include control characters and other    ♫☼§►↔◄░▒▓█┌┴┐±÷²¬└┬┘ilk.'
@=' !"#$%&''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghij' || ,
                                              'klmnopqrstuvwxyz{|}~'
$=x                                              /*set "new" string to same as the old. */
   do  until _=0;             _=verify($, @)     /*check if  any  character isn't in  @.*/
   if _\==0  then $=delstr($, _, 1)              /*Is this a bad char?   Then delete it.*/
   end   /*until*/                               /*stick a fork in it,  we're all done. */

say 'old = »»»' || x || "«««"                    /*add ««fence»» before & after old text*/
say 'new = »»»' || $ || "«««"                    /* "      "        "   "   "   new   " */
