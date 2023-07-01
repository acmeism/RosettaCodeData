\ manipulating and computing with Hamming numbers:

: extract2 ( h -- l )
    40 rshift ;

: extract3 ( h -- m )
    20 rshift $fffff and ;

: extract5 ( h -- n )
    $fffff and ;

' + alias h* ( h1 h2 -- h )

: h. { h -- }
    ." 2^"  h extract2 0 .r
    ." *3^" h extract3 0 .r
    ." *5^" h extract5 . ;

\ the following numbers have been produced with bc -l as follows
1 62 lshift constant ldscale2
 7309349404307464679 constant ldscale3 \ 2^62*l(3)/l(2) (rounded up)
10708003330985790206 constant ldscale5 \ 2^62*l(5)/l(2) (rounded down)

: hld { h -- ud }
    \ ud is a scaled fixed-point representation of the logarithm dualis of h
    h extract2 ldscale2 um*
    h extract3 ldscale3 um* d+
    h extract5 ldscale5 um* d+ ;

: h<= ( h1 h2 -- f )
    2dup = if
        2drop true exit
    then
    hld rot hld assert( 2over 2over d<> )
    du>= ;

: hmin ( h1 h2 -- h )
    2dup h<= if
        drop
    else
        nip
    then ;

\ actual algorithm

0 value seq
variable seqlast 0 seqlast !

: lastseq ( -- u )
    \ last stored number in the sequence
    seq seqlast @ th @ ;

: genseq ( h1 "name" -- )
    \ h1 is the factor for the sequence
    create , 0 , \ factor and index of element used for last return
  does> ( -- u2 )
    \ u2 is the next number resulting from multiplying h1 with numbers
    \ in the sequence that is larger than the last number in the
    \ sequence
    dup @ lastseq { h1 l } cell+ dup @ begin ( index-addr index )
        seq over th @ h1 h* dup l h<= while
            drop 1+ repeat
    >r swap ! r> ;

$10000000000 genseq s2
$00000100000 genseq s3
$00000000001 genseq s5

: nextseq ( -- )
    s2 s3 hmin s5 hmin , 1 seqlast +! ;

: nthseq ( u1 -- h )
    \ the u1 th element in the sequence
    dup seqlast @ u+do
        nextseq
    loop
    1- 0 max cells seq + @ ;

: .nseq ( u1 -- )
    dup seqlast @ u+do
        nextseq
    loop
    0 u+do
        seq i th @ h.
    loop ;

here to seq
0 , \ that's 1

20 .nseq
cr    1691 nthseq h.
cr 1000000 nthseq h.
