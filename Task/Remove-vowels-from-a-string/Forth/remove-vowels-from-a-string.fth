: VOWELS ( -- add len )  S" aeiouAEIOU" ;

: VALIDATE ( char addr len -- 0|n) ROT SCAN NIP ;     \ find char in string
: C+!     ( n addr )  TUCK C@ + SWAP C! ;             \ add n to byte address
: ]PAD    ( ndx -- addr ) PAD 1+  + ;                 \ index into text section
: PAD,    ( char -- ) PAD C@ ]PAD C!  1 PAD C+! ;     \ compile char into PAD, inc. count

: NOVOWELS ( addr len -- addr' len')
        0 PAD C!          \ reset byte count
        BOUNDS ( -- end start)
        ?DO
            I C@ DUP VOWELS VALIDATE
            IF   DROP    \ don't need vowels
            ELSE PAD,    \ compile char & incr. byte count
            THEN
        LOOP
        PAD COUNT ;
