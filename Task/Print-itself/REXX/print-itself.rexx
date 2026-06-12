/*REXX program  prints  its own multi─line source to the  standard output  (stdout).    */

    do j=1  for sourceline()
    call lineout , sourceline(j)
    end   /*j*/                                  /*stick a fork in it,  we're all done. */
