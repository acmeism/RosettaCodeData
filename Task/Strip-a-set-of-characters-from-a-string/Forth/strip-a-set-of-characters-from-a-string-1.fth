: append-char ( char str -- ) dup >r  count dup 1+ r> c! + c! ;  \ append char to a counted string
: strippers   ( -- addr len)  s" aeiAEI" ;     \ a string literal returns addr and length

: stripchars ( addr1 len1  addr2 len2 -- PAD len )
        0 PAD c!                               \ clear the PAD buffer
        bounds                                 \ calc loop limits for addr2
        DO
           2dup I C@ ( -- addr1 len1 addr1 len1 char)
           scan nip 0=                         \ scan for char in addr1, test for zero
           IF                                  \ if stack = true (ie. NOT found)
              I c@ PAD append-char             \ fetch addr2 char, append to PAD
           THEN                                \ ...then ... continue the loop
        LOOP
        2drop                                  \ we don't need STRIPPERS now
        PAD count ;                            \ return PAD address and length
