/*REXX program implements and displays  a  stateless   Y   combinator.                  */
numeric digits 1000                                               /*allow big numbers.  */
say '    fib'   Y(fib      (50) )                                 /*Fibonacci series.   */
say '    fib'   Y(fib      (12 11 10 9 8 7 6 5 4 3 2 1 0)  )      /*Fibonacci series.   */
say '   fact'   Y(fact     (60) )                                 /*single    factorial.*/
say '   fact'   Y(fact     (0 1 2 3 4 5 6 7 8 9 10 11) )          /*single    factorial.*/
say '  Dfact'   Y(dfact    (4 5 6 7 8 9 10 11 12 13)   )          /*double    factorial.*/
say '  Tfact'   Y(tfact    (4 5 6 7 8 9 10 11 12 13)   )          /*triple    factorial.*/
say '  Qfact'   Y(qfact    (4 5 6 7 8 40) )                       /*quadruple factorial.*/
say ' length'   Y(length   (when for to where whenceforth) )      /*lengths   of words. */
say 'reverse'   Y(reverse  (123 66188 3007 45.54 MAS I MA) )      /*reverses  strings.  */
say '   sign'   Y(sign     (-8 0 8) )                             /*sign of the numbers.*/
say '  trunc'   Y(trunc    (-7.0005 12 3.14159 6.4 78.999) )      /*truncates numbers.  */
say '    b2x'   Y(b2x      (1 10 11 100 1000 10000 11111 ) )      /*converts BIN──►HEX. */
say '    d2x'   Y(d2x      (8 9 10 11 12 88 89 90 91 6789) )      /*converts DEC──►HEX. */
say '    x2d'   Y(x2d      (8 9 10 11 12 88 89 90 91 6789) )      /*converts HEX──►DEC. */
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
Y: parse arg Y _; $=; do j=1 for words(_); interpret '$=$' Y"("word(_,j)')'; end; return $
/*──────────────────────────────────────────────────────────────────────────────────────*/
fib:   procedure; parse arg x;  if x<2  then return x;  s= 0;  a= 0;   b= 1
                                    do j=2  to x;  s= a+b;  a= b;  b= s;  end;    return s
/*──────────────────────────────────────────────────────────────────────────────────────*/
dfact: procedure; parse arg x;  != 1;    do j=x  to 2  by -2;   != !*j;   end;    return !
tfact: procedure; parse arg x;  != 1;    do j=x  to 2  by -3;   != !*j;   end;    return !
qfact: procedure; parse arg x;  != 1;    do j=x  to 2  by -4;   != !*j;   end;    return !
 fact: procedure; parse arg x;  != 1;    do j=2  to x       ;   != !*j;   end;    return !
