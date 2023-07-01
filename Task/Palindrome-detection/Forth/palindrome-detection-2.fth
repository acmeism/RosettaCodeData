variable temp-addr

: valid-char? ( addr1 u -- f ) ( check for valid character )
    + dup C@ 48 58 within
    over C@ 65 91 within or
    swap C@ 97 123 within or ;

: >upper ( c1 -- c2 )
    dup 97 123 within if 32 - then ;

: strip-input ( addr1 u -- addr2 u ) ( Strip characters, then copy stripped string to temp-addr )
    pad temp-addr !
    temp-addr @ rot rot 0 do dup I 2dup valid-char? if
        + C@ >upper temp-addr @ C! 1 temp-addr +!
        else 2drop
        then loop drop temp-addr @ pad - ;

: get-phrase ( -- addr1 u )
    ." Type a phrase: " here 1024 accept here swap -trailing cr ;

: position-phrase ( addr1 u -- addr1 u addr2 u addr1 addr2 u )
    temp-addr @ over 2over 2over drop swap ;

: reverse-copy ( addr1 addr2 u -- addr1 addr2 )
    0 do over I' 1- I - + over I + 1 cmove loop 2drop ;

: palindrome? ( -- )
    get-phrase strip-input position-phrase reverse-copy compare 0= if
    ." << Valid >> Palindrome."
    else ." << Not >> a Palindrome."
    then cr ;
