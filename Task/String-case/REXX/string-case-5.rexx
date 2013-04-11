/*REXX pgm  capitalizes  each word in string, maintains imbedded blanks.*/
x= "alef bet gimel dalet he vav zayin het tet yod kaf lamed mem nun samekh",
   "ayin pe tzadi qof resh shin  tav." /*"old" spelling Hebrew letters. */
y= capitalize(x)                       /*capitalize each word in string.*/
say x                                  /*show original string of words. */
say y                                  /*show the capitalized words.    */
exit                                   /*stick a fork in it, we're done.*/
/*───────────────────────────────────CAPITALIZE subroutine──────────────*/
capitalize: procedure;  parse arg z;   $=' 'z     /*prefix with a blank.*/
abc = "abcdefghijklmnopqrstuvwxyz"     /*define all lowercase letters.  */

  do j=1  for 26                       /*process each letter in alphabet*/
  _=' 'substr(abc,j,1); _U=_; upper _U /*get a lower and upper letter.  */
  $ = changestr(_, $, _U)              /*maybe capitalize some word(s). */
  end   /*j*/

return substr($,2)                     /*capitalized words,  -1st blank.*/
