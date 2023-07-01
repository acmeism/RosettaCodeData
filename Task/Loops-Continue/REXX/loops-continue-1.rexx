/*REXX program  illustrates  an example of a   DO   loop with an  ITERATE  (continue).  */

  do j=1  for 10                                 /*this is equivalent to:  DO J=1 TO 10 */
  call charout ,  j                              /*write the integer to the terminal.   */
  if j//5\==0  then do                           /*Not a multiple of five?   Then ···   */
                    call charout , ", "          /*  write a comma to the terminal, ··· */
                    iterate                      /* ··· & then go back for next integer.*/
                    end
  say                                            /*force REXX to display on next line.  */
  end   /*j*/
                                                 /*stick a fork in it,  we're all done. */
