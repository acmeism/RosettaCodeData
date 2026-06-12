/*REXX pgm counts number of decimal digits which are to the right of the decimal point. */
numeric digits 1000                              /*ensure enuf dec digs for calculations*/
@.=;                                             /*initialize a stemmed array to nulls. */
parse arg @.1;  if @.1=''  then do;      #= 9    /*#:  is the number of default numbers.*/
                                @.1 = 12
                                @.2 = 12.345
                                @.3 = 12.345555555555
                                @.4 = 12.3450
                                @.5 = 12.34555555555555555555
                                @.6 = 1.2345e+54
                                @.7 = 1.2345e-54
                                @.8 = 0.1234567890987654321
                                @.9 = 1.5 ** 63  /*calculate  1.5  raised to 63rd power.*/
                                end
                           else #= 1             /*the # of numbers specified on the CL.*/

say 'fractional'
say ' decimals '  center("number", 75)
say '══════════'  copies("═", 75)

          do j=1  for #;    n= countDec(@.j)     /*obtain the number of fractional digs.*/
          say right(n, 5)   left('',4)  @.j      /*show # of fract. digits & original #.*/
          end   /*j*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
countDec: procedure; parse upper arg x           /*obtain a number from the invoker.    */
          if pos('E', x)>0  then do              /*handle if the number has an exponent.*/
                                 LX= length(x)           /*length of the original number*/
                                 parse var x 'E' expon   /*obtain the exponent.         */
                                 LE= length(LE)          /*the length of the exponent.  */
                                 numeric digits LX + LE  /*ensure enough decimal digits.*/
                                 x= format(x, , , 0)     /*REXX does the heavy lifting. */
                                 end
          parse var x '.' fract                  /*parse number, get the fractional part*/
          return length(fract)                   /*return number of fractional digits.  */
