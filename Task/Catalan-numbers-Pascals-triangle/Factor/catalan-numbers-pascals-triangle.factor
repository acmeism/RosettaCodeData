USING: arrays grouping io kernel math prettyprint sequences ;
IN: rosetta-code.catalan-pascal

: next-row ( seq -- seq' )
    2 clump [ sum ] map 1 prefix 1 suffix ;

: pascal ( n -- seq )
    1 - { { 1 } } swap [ dup last next-row suffix ] times ;

15 2 * pascal [ length odd? ] filter [
    dup length 1 = [ 1 ]
    [ dup midpoint@ dup 1 + 2array swap nths first2 - ] if
    pprint bl
] each drop
