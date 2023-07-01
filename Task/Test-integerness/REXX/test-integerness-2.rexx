/* REXX ---------------------------------------------------------------
* Extra credit
* Instead of using the datatype built-in function one could use this
*--------------------------------------------------------------------*/
Call testi 25.000000
Call testi 24.999999
Call testi 25.000100
Call testi  0.9999999
Call testi -0.9999999
Exit

testi:
Parse Arg x
If pos('.',x)>0 Then Do
  xx=abs(x)
  Parse Value abs(xx) With '.' d
  d5=left(d,5,0)
  End
Else d5=''
If d5='' | wordpos(d5,'00000 99999')>0 Then
  Say x 'is an integer'
Else
  Say x 'isn''t an integer'
Return
