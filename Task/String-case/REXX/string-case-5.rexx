/*REXX program  capitalizes  each word in string, and maintains imbedded blanks.        */
x= "alef bet gimel dalet he vav zayin het tet yod kaf lamed mem nun samekh",
   "ayin pe tzadi qof resh shin  tav."           /*the "old" spelling of Hebrew letters.*/
y= capitalize(x)                                 /*capitalize each word in the string.  */
say x                                            /*display the original string of words.*/
say y                                            /*   "     "    capitalized      words.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
capitalize: procedure;  parse arg z;   $=' 'z    /*prefix    $    string with a  blank. */
            abc = "abcdefghijklmnopqrstuvwxyz"   /*define all  Latin  lowercase letters.*/

                      do j=1  for 26             /*process each letter in the alphabet. */
                      _=' 'substr(abc,j,1); _U=_ /*get a  lowercase  (Latin) letter.    */
                      upper _U                   /* "  "  uppercase     "       "       */
                      $=changestr(_, $, _U)      /*maybe capitalize some word(s).       */
                      end   /*j*/

            return substr($, 2)                  /*return the capitalized words.        */
