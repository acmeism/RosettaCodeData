: egcd ( a b -- a b )
    dup 0= IF
        2drop 1 0
    ELSE
        dup -rot /mod               \ -- b r=a%b q=a/b
        -rot recurse                \ -- q (s,t) = egcd(b, r)
        >r swap r@ * - r> swap      \ -- t (s - q*t)
    THEN ;

: egcd>gcd  ( a b x y -- n )  \ calculate gcd from egcd
    rot * -rot * + ;

: mod-inv  ( a m -- a' )     \ modular inverse with coprime check
    2dup egcd over >r egcd>gcd r> swap 1 <> -24 and throw ;

: array-product ( adr count -- n )
    1 -rot  cells bounds ?DO  i @ *  cell +LOOP ;

: crt-from-array  ( adr1 adr2 count -- n )
    2dup array-product   locals| M count m[] a[] |
    0  \ result
    count 0 DO
        m[] i cells + @
        dup M swap /
        dup rot mod-inv *
        a[] i cells + @ * +
    LOOP  M mod ;

create crt-residues[]  10 cells allot
create crt-moduli[]    10 cells allot

: crt ( .... n -- n )  \ takes pairs of "n (mod m)" from stack.
    10 min  locals| n |
    n 0 DO
        crt-moduli[] i cells + !
        crt-residues[] i cells + !
    LOOP
    crt-residues[] crt-moduli[] n crt-from-array ;
