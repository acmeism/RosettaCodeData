/* REXX **************************************************************
* Derived from PL/I with a little "massage"
* SQRT2=     1.41421356237309505              <- PL/I Result
*            1.41421356237309504880168872421  <- REXX Result 30 digits
* NAPIER=    2.71828182845904524
*            2.71828182845904523536028747135
* PI=        3.14159262280484695
*            3.14159262280484694855146925223
* 06.09.2012 Walter Pachl
**********************************************************************/
  Numeric Digits 30
  Parse Value '1 2 3 0 0' with Sqrt2 napier pi a b
  Say left('SQRT2=' ,10) calc(sqrt2,  200)
  Say left('NAPIER=',10) calc(napier, 200)
  Say left('PI='    ,10) calc(pi,     200)
  Exit

Get_Coeffs: procedure Expose a b Sqrt2 napier pi
  Parse Arg form, n
  select
    when form=Sqrt2 Then do
      if n > 0 then a = 2; else a = 1
      b = 1
      end
    when form=Napier Then do
      if n > 0 then a = n; else a = 2
      if n > 1 then b = n - 1; else b = 1
      end
    when form=pi Then do
      if n > 0 then a = 6; else a = 3
      b = (2*n - 1)**2
      end
    end
  Return

Calc: procedure Expose a b Sqrt2 napier pi
  Parse Arg form,n
  Temp=0
  do ni = n to 1 by -1
    Call Get_Coeffs form, ni
    Temp = B/(A + Temp)
    end
  call Get_Coeffs  form, 0
  return (A + Temp)
