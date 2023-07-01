/*REXX program emulates a multiple─range  DO  loop  (all variables can be any numbers). */
 prod=  1;
  sum=  0;
    x= +5;
    y= -5;
    z= -2;
  one=  1;
three=  3;
seven=  7;

      do j=   -three  to      3**3      by three  ;      call meat;      end;
      do j=   -seven  to    seven       by   x    ;      call meat;      end;
      do j=      555  to      550 - y             ;      call meat;      end;
      do j=       22  to      -28       by -three ;      call meat;      end;
      do j=     1927  to     1939                 ;      call meat;      end;
      do j=        x  to        y       by   z    ;      call meat;      end;
      do j=    11**x  to    11**x + one           ;      call meat;      end;

say ' sum= ' || commas( sum);                          /*display   SUM   with commas.   */
say 'prod= ' || commas(prod);                          /*   "     PROD     "     "      */
exit;                                                  /*stick a fork in it, we're done.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: procedure; parse arg _;     n= _'.9';     #= 123456789;     b= verify(n, #, "M")
                                    e= verify(n, #'0', , verify(n, #"0.", 'M') )  - 4
          do j=e  to b  by -3;      _= insert(',', _, j);   end;                  return _
/*──────────────────────────────────────────────────────────────────────────────────────*/
meat:  sum= sum + abs(j);
       if abs(prod)<2**27 & j\==0  then prod= prod * j;
       return;
