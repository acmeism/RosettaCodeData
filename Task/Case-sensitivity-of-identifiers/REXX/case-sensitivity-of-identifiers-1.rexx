/*REXX program demonstrate  case insensitivity  for  simple  REXX  variable names.      */

  /*  ┌──◄── all 3 left─hand side REXX variables are identical (as far as assignments). */
  /*  │                                                                                 */
  /*  ↓                                                                                 */
     dog= 'Benjamin'                             /*assign a   lowercase   variable (dog)*/
     Dog= 'Samba'                                /*   "   "  capitalized     "      Dog */
     DOG= 'Bernie'                               /*   "   an  uppercase      "      DOG */

                              say center('using simple variables', 35, "─")     /*title.*/
                              say

if dog\==Dog | DOG\==dog  then say 'The three dogs are named:'     dog"," Dog 'and' DOG"."
                          else say 'There is just one dog named:'  dog"."

                                                 /*stick a fork in it,  we're all done. */
