/*REXX program to display:               1, 2, 3, 4, 5, 6, 7, 8, 9, 10   */

      do j=1  to 10
      call charout ,j                   /*write the DO loop index (no LF)*/
      if j<10  then call charout ,", "  /*append a comma for 1-digit nums*/
      end    /*j*/
                                        /*stick a fork in it, we're done.*/
