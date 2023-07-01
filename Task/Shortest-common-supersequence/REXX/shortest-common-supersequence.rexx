/*REXX program finds the  Shortest common supersequence (SCS)  of two character strings.*/
parse arg u v .                                  /*obtain optional arguments from the CL*/
if u=='' | u==","  then u= 'abcbdab'             /*Not specified?  Then use the default.*/
if v=='' | v==","  then v= 'bdcaba'              /* "      "         "   "   "     "    */
say '                     string u='  u          /*echo the value of string  U  to term.*/
say '                     string v='  v          /*  "   "    "    "    "    V   "   "  */
$= u                                             /*define initial value for the output. */
      do n=1    to length(u)                     /*process the whole length of string U.*/
        do m=n  to length(v) - 1                 /*   "    right─ish  part   "    "   V.*/
        p= pos( substr(v, m, 1), $)              /*position of mTH  V  char in $ string.*/
        _= substr(v, m+1, 1)                     /*obtain a single character of string V*/
        if p\==0  &  _\==substr($, p+1, 1)  then $= insert(_, $, p)
        end   /*m*/                              /* [↑]  insert _ in $ after position P.*/
      end     /*n*/
say
say 'shortest common supersequence='  $          /*stick a fork in it,  we're all done. */
