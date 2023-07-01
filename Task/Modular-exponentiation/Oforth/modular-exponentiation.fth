: powmod(base, exponent, modulus)
   1 exponent dup ifZero: [ return ]
    while ( dup 0 > ) [
      dup isEven ifFalse: [ swap base * modulus mod swap ]
      2 / base sq modulus mod ->base
      ] drop ;
