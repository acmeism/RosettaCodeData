/*REXX program converts decimal numbers to the Mayan numbering system (with cartouches).*/
parse arg $                                      /*obtain optional arguments from the CL*/
if $=''  then $= 4005  8017  326205  886205,     /*Not specified?  Then use the default.*/
                 172037122592320200101           /*Morse code for MAYAN; egg is a blank.*/

  do j=1  for words($)                           /*convert each of the numbers specified*/
  #= word($, j)                                  /*extract a number from (possible) list*/
  say
  say  center('converting the decimal number '     #     " to a Mayan number:", 90,  '─')
  say
  call $MAYAN   #   '(overlap)'                  /*invoke the  $MAYAN (REXX) subroutine.*/
  say
  end   /*j*/                                    /*stick a fork in it,  we're all done. */
