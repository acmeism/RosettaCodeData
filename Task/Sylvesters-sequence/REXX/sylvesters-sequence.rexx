/*REXX pgm finds N terms of the Sylvester's sequence & the sum of the their reciprocals.*/
parse arg n .                                    /*obtain optional argument from the CL.*/
if n=='' | n==","  then n= 10                    /*Not specified?  Then use the default.*/
numeric digits max(9, 2**(n-7) * 13 + 1)         /*calculate how many dec. digs we need.*/
@.0= 2                                           /*the value of the 1st Sylvester number*/
$= 0
        do j=0  for n;      jm= j - 1            /*calculate the Sylvester sequence.    */
        if j>0  then @.j= @.jm**2 - @.jm + 1     /*calculate  a  Sylvester sequence num.*/
        say 'Sylvester('j") ──► "   @.j          /*display the Sylvester index & number.*/
        $= $   +   1 / @.j                       /*add its reciprocal to the recip. sum.*/
        end   /*j*/
say                                              /*stick a fork in it,  we're all done. */
numeric digits digits() - 1
say 'sum of the first '   n   " reciprocals using"   digits()   'decimal digits: '   $ / 1
