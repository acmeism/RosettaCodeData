/* REXX ************************************************************
* There is no equivalent to PL/I's SIZE condition in REXX.
* The result of an arithmetic expression is rounded
* according to the current setting of Numeric Digits.
* ooRexx introduced, however, a LOSTDIGITS condition that checks
* if any of the OPERANDS exceeds this number of digits.
*      Unfortunately this check is currently a little too weak
*      and will not recognise a 10-digit number to be too large.
*      This little bug will be fixed in the next release of ooRexx.
**********************************************************************/
Parse Version v .
Say v
z=999999998
Do i=1 To 3
  z=z+1
  Say z
  End
Numeric Digits 20
z=999999998
Do i=1 To 3
  z=z+1
  Say z
  End
Numeric Digits 9
If left(v,11)='REXX-ooRexx' Then
  Signal On Lostdigits
z=100000000012
Say z
z=z+1
Say z
Exit
lostdigits:
  Say 'LOSTDIGITS condition raised in line' sigl
  Say 'sourceline='sourceline(sigl)
  Say "condition('D')="condition('D')
