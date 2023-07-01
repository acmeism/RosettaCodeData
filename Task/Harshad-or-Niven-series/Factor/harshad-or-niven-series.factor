USING: math.text.utils lists lists.lazy ;

: niven? ( n -- ? ) dup 1 digit-groups sum mod 0 = ;

: first-n-niven ( n -- seq )
    1 lfrom [ niven? ] lfilter ltake list>array ;

: next-niven ( n -- m ) 1 + [ dup niven? ] [ 1 + ] until ;

20 first-n-niven .
1000 next-niven .
