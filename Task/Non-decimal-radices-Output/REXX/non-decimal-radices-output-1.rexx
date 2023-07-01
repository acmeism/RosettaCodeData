/*REXX pgm shows REXX's ability to show decimal numbers in binary & hex.*/

      do j=0  to 50                /*show some low-value num conversions*/
      say right(j,3)         ' in decimal is',
          right(d2b(j),12)   " in binary",
          right(d2x(j),12)   ' in hexadecimal.'
      end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*────────────────────────────D2B subroutine────────────────────────────*/
d2b: return word(strip(x2b(d2x(arg(1))),'L',0) 0,1)  /*convert dec──►bin*/
