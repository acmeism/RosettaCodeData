/* REXX ***************************************************************
* using PL/I code extended to many arguments
* 17.08.2012 Walter Pachl
* 18.08.2012 gcd(0,0)=0
**********************************************************************/
numeric digits 300                  /*handle up to 300 digit numbers.*/
Call test  7,21     ,'7 '
Call test  4,7      ,'1 '
Call test 24,-8     ,'8'
Call test 55,0      ,'55'
Call test 99,15     ,'3 '
Call test 15,10,20,30,55,'5'
Call test 496,8128  ,'16'
Call test 496,8128  ,'8'            /* test wrong expectation        */
Call test 0,0       ,'0'            /* by definition                 */
Exit

test:
/**********************************************************************
* Test the gcd function
**********************************************************************/
n=arg()                             /* Number of arguments           */
gcde=arg(n)                         /* Expected result               */
gcdx=gcd(arg(1),arg(2))             /* gcd of the first 2 numbers    */
Do i=2 To n-2                       /* proceed with all te others    */
  If arg(i+1)<>0 Then
    gcdx=gcd(gcdx,arg(i+1))
  End
If gcdx=arg(arg()) Then             /* result is as expected         */
  tag='as expected'
Else                                /* result is not correct         */
  Tag='*** wrong. expected:' gcde
numbers=arg(1)                      /* build sting to show the input */
Do i=2 To n-1
  numbers=numbers 'and' arg(i)
  End
say left('the GCD of' numbers 'is',45) right(gcdx,3) tag
Return

GCD: procedure
/**********************************************************************
* Recursive procedure as shown in PL/I
**********************************************************************/
Parse Arg a,b
if b = 0 then return abs(a)
return GCD(b,a//b)
