: ceasar(c, key)
   c dup isLetter ifFalse: [ return ]
   isUpper ifTrue: [ 'A' ] else: [ 'a' ] c key + over - 26 mod + ;

: cipherE(s, key)  s map(#[ key ceasar ]) charsAsString ;
: cipherD(s, key)  cipherE(s, 26 key - ) ;
