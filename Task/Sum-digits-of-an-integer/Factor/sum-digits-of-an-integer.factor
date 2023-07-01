: sum-digits ( base n -- sum ) 0 swap [ dup zero? ] [ pick /mod swapd + swap ] until drop nip ;

{ 10 10 16 16 } { 1 1234 0xfe 0xf0e } [ sum-digits ] 2each
