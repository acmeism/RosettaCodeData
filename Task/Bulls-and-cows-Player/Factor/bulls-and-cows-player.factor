USING: arrays combinators.short-circuit formatting fry io kernel
math math.combinatorics math.functions math.order math.parser
math.ranges random regexp sequences sets splitting ;

: bulls ( seq1 seq2 -- n ) [ = 1 0 ? ] 2map sum ;
: cows ( seq1 seq2 -- n ) [ intersect length ] [ bulls - ] 2bi ;
: score ( seq1 seq2 -- pair ) [ bulls ] [ cows 2array ] 2bi ;
: possibilities ( -- seq ) 9 [1,b] 4 <k-permutations> ;
: pare ( seq guess score -- new-seq ) '[ _ score _ = ] filter ;
: >number ( seq -- n ) reverse [ 10^ * ] map-index sum ;
: >score ( str -- pair ) "," split [ string>number ] map ;
: ask ( n -- ) "My guess is %d. How many bulls, cows? " printf ;

: valid-input? ( str -- ? )
    { [ R/ \d,\d/ matches? ] [ >score sum 0 4 between? ] } 1&& ;

: get-score ( n -- pair )
    [ ask ] keep flush readln dup valid-input?
    [ nip >score ] [ drop get-score ] if ;

: game ( seq -- )
    dup random [
        dup >number get-score dup first 4 =
        [ 3drop "Success!" print ] [ pare game ] if
    ] [ drop "Scoring inconsistency." print ] if* ;

possibilities game
