/* REXX */
s="123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
Numeric Digits 1000
cnt_ok=0
Call test 'N',25420294593250030202636073700053352635053786165627414518,,
             '6UwLL9Risc3QfPqBUvKofHmBQ7wMtjvM'
Call test 'X','61'x                                      ,'2g'
Call test 'X','626262'x                                  ,'a3gV'
Call test 'X','636363'x                                  ,'aPEr'
Call test 'X','73696d706c792061206c6f6e6720737472696e67'x,,
              '2cFupjhnEsSn59qHXstmK2ffpLv2'
Call test 'X','516b6fcd0f'x                              ,'ABnLTmg'
Call test 'X','bf4f89001e670274dd'x                      ,'3SEo3LWLoPntC'
Call test 'X','572e4794'x                                ,'3EFU7m'
Call test 'X','ecac89cad93923c02321'x                    ,'EJDM8drfXA6uyA'
Call test 'X','10c8511e'x                                ,'Rt5zm'
Call test 'X','10c8511e'x                                ,'check_error_handlimng'
Say cnt_ok 'tests ok'
Exit
test:
  Parse Arg how,k,res
  If how='X' Then
    k=c2d(k)
  o=''
  Do Until k=0
    rem=k//58
    k=k%58
    o=o||substr(s,rem+1,1)
    End
  o=reverse(o)
  If o=res Then cnt_ok+=1
  Else Do
    Say 'expected:' res
    Say 'found   :' o
    End
  Return
