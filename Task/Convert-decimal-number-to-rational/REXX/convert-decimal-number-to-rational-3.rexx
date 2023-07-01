/* REXX ---------------------------------------------------------------
* 13.02.2014 Walter Pachl
* specify the number as xxx.yyy(pqr) pqr is the period
*        for the number xxx.yyypqrpqrpqrpqrpqr...
*--------------------------------------------------------------------*/
Numeric Digits 100
Call test '5.55555','111111/20000'
Call test '3','3'
Call test '0.03','3/100'
Call test '0.9(054)','67/74'
Call test '0.(3)','1/3'
Call test '5.28(571428)','37/7'
Call test '5.28(571428)','38/7 (demonstrate error case)'
Call test '0.(518)','14/27'
Call test '0.75'        ,'3/4'
Call test '0.(142857)','1/7'
Call test '0.1(428571)','1/7'
Call test '35.000','35'
Call test '35.001','35001/1000'
Call test '0.00000000001','1/100000000000'
Call test '0.000001000001','1000001/1000000000000'
Exit
test:
  Parse Arg z, soll
  zin=z
  If pos('(',z)=0 Then Do
    Parse Var z i '.' f
    z=i||f
    n=10**length(f)
    End
  Else Do
    lp=pos('(',z)-3
    rp=pos(')',z)-4
    x=space(translate(z,'  ','()'),0)
    z1=x*10**lp
    Parse Var z1 z1 '.'
    z2=x*10**rp
    z=z2-z1
    n=10**rp-10**lp
    End
  dd=gcd(z,n)
  zz=z/dd
  nn=n/dd
  If nn=1 Then
    fract=zz
  Else
    fract=zz'/'nn
  If fract==soll Then
    tag='ok'
  Else
    tag='should be' soll
  say zin '=' fract tag
   Return

GCD: procedure
/**********************************************************************
* Recursive procedure
**********************************************************************/
Parse Arg a,b
if b = 0 then return abs(a)
return GCD(b,a//b)
