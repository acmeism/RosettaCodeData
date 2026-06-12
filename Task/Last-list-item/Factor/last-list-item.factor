USING: formatting io kernel math math.statistics prettyprint
sequences sequences.extras ;

: list. ( seq -- )
    "List: " write [ bl ] [ pprint ] interleave nl ;

: smallest. ( seq -- )
    first2 2dup + "Two smallest: %d + %d = %d\n" printf ;

: remove-all-first! ( seq elts -- seq' )
    [ swap remove-first! ] each ;

: step ( seq -- seq' )
    dup { 0 1 } kth-smallests tuck remove-all-first! over
    smallest. swap sum suffix! ;

V{ 6 81 243 14 25 49 123 69 11 }
[ dup length 1 > ] [ dup list. step ] while
last "Last item is %d.\n" printf
