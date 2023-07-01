/* REXX ---------------------------------------------------------------
* 20.06.2014 Walter Pachl
* 22.06.2014 WP add complex numbers such as 13-12j etc.
* (using 13e-12 or so is not (yet) supported)
*--------------------------------------------------------------------*/
Call test_integer 3.14
Call test_integer 1.00000
Call test_integer 33
Call test_integer 999999999
Call test_integer 99999999999
Call test_integer 1e272
Call test_integer 'AA'
Call test_integer '0'
Call test_integer '1.000-3i'
Call test_integer '1.000-3.3i'
Call test_integer '4j'
Call test_integer '2.00000000+0j'
Call test_integer '0j'
Call test_integer '333'
Call test_integer '-1-i'
Call test_integer '1+i'
Call test_integer '.00i'
Call test_integer 'j'
Call test_integer '0003-00.0j'
Exit

test_integer:
Parse Arg xx
Numeric Digits 1000
Parse Value parse_number(xx) With x imag
If imag<>0 Then Do
  Say left(xx,13) 'is not an integer (imaginary part is not zero)'
  Return
  End
Select
  When datatype(x)<>'NUM' Then
    Say left(xx,13) 'is not an integer (not even a number)'
  Otherwise Do
    If datatype(x,'W') Then
      Say left(xx,13) 'is an integer'
    Else
      Say left(xx,13) 'isn''t an integer'
    End
  End
Return
parse_number: Procedure
  Parse Upper Arg x
  x=translate(x,'I','J')
  If pos('I',x)>0 Then Do
    pi=verify(x,'+-','M')
    Select
      When pi>1 Then Do
        real=left(x,pi-1)
        imag=substr(x,pi)
        End
      When pi=0 Then Do
        real=0
        imag=x
        End
      Otherwise /*pi=1*/Do
        p2=verify(substr(x,2),'+-','M')
        If p2>0 Then Do
          real=left(x,p2)
          imag=substr(x,p2+1)
          End
        Else Do
          real=0
          imag=x
          End
        End
      End
    End
  Else Do
    real=x
    imag='0I'
    End
  pi=verify(imag,'+-','M')
  If pi=0 Then Do
    Parse Var imag imag_v 'I'
    imag_sign='+'
    End
  Else
    Parse Var imag imag_sign 2 imag_v 'I'
  If imag_v='' Then
    imag_v=1
  imag=imag_sign||imag_v

  Return real imag
