: halve   2 / ;
: double  2 * ;

: ethiopian
   dup ifZero: [ nip return ]
   over double over halve ethiopian
   swap isEven ifTrue: [ nip ] else: [ + ] ;
