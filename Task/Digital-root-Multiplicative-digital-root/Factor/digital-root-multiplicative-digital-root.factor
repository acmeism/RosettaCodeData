USING: arrays formatting fry io kernel lists lists.lazy math
math.text.utils prettyprint sequences ;
IN: rosetta-code.multiplicative-digital-root

: mdr ( n -- {persistence,root} )
    0 swap
    [ 1 digit-groups dup length 1 > ] [ product [ 1 + ] dip ] while
    dup empty? [ drop { 0 } ] when first 2array ;

: print-mdr ( n -- )
    dup [ 1array ] dip mdr append
    "%-12d has multiplicative persistence %d and MDR %d.\n"
    vprintf ;

: first5 ( n -- seq ) ! first 5 numbers with MDR of n
    0 lfrom swap '[ mdr second _ = ] lfilter 5 swap ltake list>array ;

: print-first5 ( i n -- )
    "%-5d" printf bl first5 [ "%-5d " printf ] each nl ;

: header ( -- )
    "MDR | First five numbers with that MDR" print
    "--------------------------------------" print ;

: first5-table ( -- )
    header 10 iota [ print-first5 ] each-index ;

: main ( -- )
    { 123321 7739 893 899998 } [ print-mdr ] each nl first5-table ;

MAIN: main
