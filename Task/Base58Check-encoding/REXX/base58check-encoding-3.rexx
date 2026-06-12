/*REXX pgm encodes a checksum (hash digest) into Base58 (the standard Bitcoin alphabet).*/
           /*  0─────────────────I─────O────────────────────l────────────────  ◄───omit.*/
     @= space(" 123456789ABCDEFGH JKLMN PQRSTUVWXYZabcdefghi jkmnopqrstuvwxyz",  0)
numeric digits 500                               /*just in case there're huge numberss. */
say  B58(25420294593250030202636073700053352635053786165627414518)
say  B58('61'x)           ;         say  B58('626262'x)
say  B58('636363'x)       ;         say  B58('73696d706c792061206c6f6e6720737472696e67'x)
say  B58('516b6fcd0f'x)   ;         say  B58('bf4f89001e670274dd'x)
say  B58('572e4794'x)     ;         say  B58('ecac89cad93923c02321'x)
say  B58('10c8511e'x)
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
B58: parse arg z 1 oz,,$;    L1= 0;           hex= 0;  if z=''  then return /*Z missing?*/
     if \datatype(z, 'W') | arg()>1  then do; hex= 1;  z= c2d(z);  end      /*Z in hex? */
     if left(z, 1)==1  then L1= verify(z ., 1) - 1  /*count number of leading ones (1's)*/
                                    do until z==0;  $= substr(@, z//58 +1, 1)$;  z= z % 58
                                    end  /*until*/
     if hex  then oz= "'"c2x(oz)"'x"                /*Original arg in hex? Transform it.*/
     return right(oz, 60) "───►"  left('', L1, 0)$  /*for showing arg and the residual. */

