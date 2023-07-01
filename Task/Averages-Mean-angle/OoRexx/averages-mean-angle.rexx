/*REXX program computes the  mean angle  (angles expressed in degrees). */
numeric digits 50                      /*use fifty digits of precision, */
       showDig=10                      /*··· but only display 10 digits.*/
xl = 350 10            ;      say showit(xl, meanAngleD(xl) )
xl = 90 180 270 360    ;      say showit(xl, meanAngleD(xl) )
xl = 10 20 30          ;      say showit(xl, meanAngleD(xl) )
exit                                   /*stick a fork in it, we're done.*/
/*----------------------------------MEANANGD subroutine-----------------*/
meanAngleD:  procedure;  parse arg xl;   numeric digits digits()+digits()%4
sum.=0
n=words(xl)
do j=1 to n
  sum.0sin+=rxCalcSin(word(xl,j))
  sum.0cos+=rxCalcCos(word(xl,j))
  End
If sum.0cos=0 Then
  Return sign(sum.0sin/n)*90
Else
  Return rxCalcArcTan((sum.0sin/n)/(sum.0cos/n))

showit: procedure expose showDig;  numeric digits showDig;  parse arg a,mA
        return left('angles='a,30)  'mean angle='  format(mA,,showDig,0)/1

::requires rxMath library;
