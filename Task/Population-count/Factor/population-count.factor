USING: formatting kernel lists lists.lazy math math.bitwise
math.functions namespaces prettyprint.config sequences ;

: 3^n ( obj -- obj' ) [ 3 swap ^ bit-count ] lmap-lazy ;
: evil ( obj -- obj' ) [ bit-count even? ] lfilter ;
: odious ( obj -- obj' ) [ bit-count odd? ] lfilter ;

100 margin set 0 lfrom [ 3^n ] [ evil ] [ odious ] tri
[ 30 swap ltake list>array ] tri@
"3^n:    %u\nEvil:   %u\nOdious: %u\n" printf
