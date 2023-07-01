USING: arrays formatting kernel math math.text.utils sequences ;
IN: rosetta-code.digital-root

: digital-root ( n -- persistence root )
    0 swap [ 1 digit-groups dup length 1 > ] [ sum [ 1 + ] dip ]
    while first ;

: print-root ( n -- )
    dup digital-root
    "%-12d has additive persistence %d and digital root %d.\n"
    printf ;

{ 627615 39390 588225 393900588225 } [ print-root ] each
