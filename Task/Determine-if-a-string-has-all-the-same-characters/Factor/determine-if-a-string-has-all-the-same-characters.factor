USING: formatting io kernel math.parser sequences ;

: find-diff ( str -- i elt ) dup ?first [ = not ] curry find ;
: len. ( str -- ) dup length "%u — length %d — " printf ;
: same. ( -- ) "contains all the same character." print ;
: diff. ( -- ) "contains a different character at " write ;

: not-same. ( i elt -- )
    dup >hex diff. "index %d: '%c' (0x%s)\n" printf ;

: sameness-report. ( str -- )
    dup len. find-diff dup [ not-same. ] [ 2drop same. ] if ;

{
    ""
    "   "
    "2"
    "333"
    ".55"
    "tttTTT"
    "4444 444k"
} [ sameness-report. ] each
