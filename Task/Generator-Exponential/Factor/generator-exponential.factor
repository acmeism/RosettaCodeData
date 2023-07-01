USING: fry kernel lists lists.lazy math math.functions
prettyprint ;
IN: rosetta-code.generator-exponential

: mth-powers-generator ( m -- lazy-list )
    [ 0 lfrom ] dip [ ^ ] curry lmap-lazy ;

: lmember? ( elt list -- ? )
    over '[ unswons dup _ >= ] [ drop ] until nip = ;

: 2-not-3-generator ( -- lazy-list )
    2 mth-powers-generator
    [ 3 mth-powers-generator lmember? not ] <lazy-filter> ;

10 2-not-3-generator 20 [ cdr ] times ltake list>array .
