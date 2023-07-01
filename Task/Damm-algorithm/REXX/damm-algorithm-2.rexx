/*REXX pgm uses H. Michael Damm's algorithm to validate numbers with suffixed check sum.*/
   @.0= 0317598642;  @.1= 7092154863;  @.2= 4206871359;  @.3= 1750983426;  @.4= 6123045978
   @.5= 3674209581;  @.6= 5869720134;  @.7= 8945362017;  @.8= 9438617205;  @.9= 2581436790
call Damm  5724,   5727,   112946,   112940      /*invoke Damm's algorithm for some #'s.*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
Damm: do j=1  for arg();       x= arg(j);        $= 0;                      z= right(x, 1)
            do p=1  for length(x);     g=$;      $= substr(@.$,  1 + substr(x, p, 1),   1)
            end   /*p*/
      if $==0  then say '   valid checksum digit '  z  " for "  x
               else say ' invalid checksum digit '  z  " for "  x    '   (should be'  g")"
      end   /*j*/;                return
