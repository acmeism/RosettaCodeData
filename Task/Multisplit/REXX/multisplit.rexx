/*REXX program to split a string based on different separator strings.  */
parse arg ?                            /*get string from command line.  */
if ?==''  then ? = 'a!===b=!=c'        /*None specified?    Use default.*/
say 'old string='?                     /*echo the old string to screen. */
zz   = '0'x                            /*null char, can be most anything*/
seps = '== != ='                       /*a list of seperaters to be used*/

  do j=1  for words(seps)              /*parse string with all the seps.*/
  sep=word(seps,j)                     /*pick a separater to use now.   */

      do k=1  for length(sep)          /*parse for various sep versions.*/
      sep=strip(insert(zz,sep,k),,zz)  /*allow imbedded "nulls" in sep. */
      ?=changestr(sep,?,zz)            /* ··· but not trailing "nulls". */

         do until ?==??;   ??=?        /*keep changing until no more chg*/
         ?=changestr(zz || zz, ?, zz)  /*reduce replicated "nulls".     */
         end   /*until···*/

      sep=changestr(zz, sep, '')       /*remove true nulls from the sep.*/
      end      /*k*/
  end          /*j*/

showNull = ' {} '                      /*one last change, allow the ... */
?=changestr(zz,?,showNull)             /*showing of "null" characters.  */
say 'new string='?                     /*now, show and tell time.       */
                                       /*stick a fork in it, we're done.*/
