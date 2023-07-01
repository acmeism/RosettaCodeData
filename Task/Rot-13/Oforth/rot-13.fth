: encryptRot13(c)
   c dup isLetter ifFalse: [ return ]
   isUpper ifTrue: [ 'A' ] else: [ 'a' ] c 13 + over - 26 mod + ;

: rot13   map(#encryptRot13) charsAsString ;
