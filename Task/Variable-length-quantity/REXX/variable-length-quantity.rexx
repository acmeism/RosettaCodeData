/*REXX program to test displaying of octets. */

num1=x2d(200000)          ;  say 'number1='num1  '  [in hex='d2x(num1)"]"
num2=x2d(1fffff)          ;  say 'number2='num2  '  [in hex='d2x(num2)"]"
num3=2097172              ;  say 'number3='num3  '  [in hex='d2x(num3)"]"
num4=2097151              ;  say 'number4='num4  '  [in hex='d2x(num4)"]"
                             say
onum1=octet(num1)         ;  say 'number1 octet='onum1
onum2=octet(num2)         ;  say 'number2 octet='onum2
onum3=octet(num3)         ;  say 'number3 octet='onum3
onum4=octet(num4)         ;  say 'number4 octet='onum4
                             say
bnum1=x2d(space(onum1,0)) ;  say 'number1='bnum1
bnum2=x2d(space(onum2,0)) ;  say 'number2='bnum2
bnum3=x2d(space(onum3,0)) ;  say 'number3='bnum3
bnum4=x2d(space(onum4,0)) ;  say 'number4='bnum4
                             say
if num1==bnum1 &,
   num2==bnum2 &,
   num3==bnum3 &,
   num4==bnum4    then say 'numbers are OK'
                  else say 'trouble in River City'
exit                                 /*stick a fork in it, we're done.*/
/*──────────────────────────────────OCTET subroutine────────────────────*/
octet: procedure; parse arg a,_; x=d2x(a)    /*convert  A  to hex octet.*/

         do j=length(x) by -2 to 1           /*process little end first.*/
         _=substr(x,j-1,2,0) _      /*pad odd hexchars with an 0 on left*/
         end   /*j*/
return _
