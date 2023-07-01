! rosetta/hailstone/length/length.factor
USING: assocs kernel io math math.ranges prettyprint
       rosetta.hailstone sequences ;
IN: rosetta.hailstone.length

<PRIVATE
: f>0 ( object/f -- object/0 )
    dup [ drop 0 ] unless ;

: max-value ( pair1 pair2 -- pair )
    [ [ second ] bi@ > ] most ;

: main ( -- )
    H{ } clone      ! Maps sequence length => count.
    1 100000 [a,b) [
        hailstone length                ! Find sequence length.
        over [ f>0 1 + ] change-at      ! Add 1 to count.
    ] each
    ! Find the length-count pair with the highest count.
    >alist unclip-slice [ max-value ] reduce
    first2 swap
    "Among Hailstone sequences from 1 <= n < 100000," print
    "there are " write pprint
    " sequences of length " write pprint "." print ;
PRIVATE>

MAIN: main
