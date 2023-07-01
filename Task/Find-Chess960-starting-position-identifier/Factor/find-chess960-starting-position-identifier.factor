USING: assocs assocs.extras combinators formatting kernel
literals math math.combinatorics sequences sequences.extras sets
strings ;

IN: scratchpad

! ====== optional error-checking ======

: check-length ( str -- )
    length 8 = [ "Must have 8 pieces." throw ] unless ;

: check-one ( str -- )
    "KQ" counts [ nip 1 = not ] assoc-find nip
    [ 1string "Must have one %s." sprintf throw ] [ drop ] if ;

: check-two ( str -- )
    "BNR" counts [ nip 2 = not ] assoc-find nip
    [ 1string "Must have two %s." sprintf throw ] [ drop ] if ;

: check-king ( str -- )
    "QBN" without "RKR" =
    [ "King must be between rooks." throw ] unless ;

: check-bishops ( str -- )
    CHAR: B swap indices sum odd?
    [ "Bishops must be on opposite colors." throw ] unless ;

: check-sp ( str -- )
    {
        [ check-length ]
        [ check-one ]
        [ check-two ]
        [ check-king ]
        [ check-bishops ]
    } cleave ;

! ====== end optional error-checking ======


CONSTANT: convert $[ "RNBQK" "♖♘♗♕♔" zip ]

CONSTANT: table $[ "NN---" all-unique-permutations ]

: knightify ( str -- newstr )
    [ dup CHAR: N = [ drop CHAR: - ] unless ] map ;

: n ( str -- n ) "QB" without knightify table index ;

: q ( str -- q ) "B" without CHAR: Q swap index ;

: d ( str -- d ) CHAR: B swap <evens> index ;

: l ( str -- l ) CHAR: B swap <odds> index ;

: sp-id ( str -- n )
    dup check-sp
    { [ n 96 * ] [ q 16 * + ] [ d 4 * + ] [ l + ] } cleave ;

: sp-id. ( str -- )
    dup [ convert substitute ] [ sp-id ] bi
    "%s / %s: %d\n" printf ;

"QNRBBNKR" sp-id.
"RNBQKBNR" sp-id.
"RQNBBKRN" sp-id.
"RNQBBKRN" sp-id.
