/*REXX program splits a  string  based on different  separator  strings.*/
parse arg ?                            /*get string from command line.  */
if ?==''  then ? = "a!===b=!=c"        /*None specified?    Use default.*/
say 'old string='?                     /*echo the old string to screen. */
zz   = '0'x                            /*null char, can be most anything*/
seps = '== != ='                       /*a list of seperators to be used*/
                                       /* [↓]   process tokens in  SEPS.*/
  do j=1  for words(seps)              /*parse string with all the seps.*/
  sep=word(seps,j)                     /*pick a separator to use now.   */
                                       /* [↓]   process chars in the sep*/
      do k=1  for length(sep)          /*parse for various sep versions.*/
      sep=strip(insert(zz,sep,k),,zz)  /*allow imbedded "nulls" in sep. */
      ?=changestr(sep,?,zz)            /* ··· but not trailing "nulls". */
                                       /* [↓]   process strings in input*/
         do until ?==??;   ??=?        /*keep changing until no more chg*/
         ?=changestr(zz || zz, ?, zz)  /*reduce replicated "nulls".     */
         end   /*until···*/
                                       /* [↓]  use BIF or external prog.*/
      sep=changestr(zz, sep, '')       /*remove true nulls from the sep.*/
      end      /*k*/
  end          /*j*/

showNull = ' {} '                      /*one more thing, display the ···*/
?=changestr(zz,?,showNull)             /*  ··· showing of "null" chars. */
say 'new string='?                     /*now, display the new string.   */
                                       /*stick a fork in it, we're done.*/
