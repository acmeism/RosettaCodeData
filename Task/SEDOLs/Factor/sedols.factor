USING: combinators combinators.short-circuit formatting io kernel
math math.parser regexp sequences unicode ;
IN: rosetta-code.sedols

<PRIVATE

CONSTANT: input {
    "710889" "B0YBKJ" "406566" "B0YBLH" "228276" "B0YBKL"
    "557910" "B0YBKR" "585284" "B0YBKT" "B00030" "AEIOUA"
    "123"    ""       "B_7K90"
}

CONSTANT: weights B{ 1 3 1 7 3 9 1 }

: sedol-error ( seq -- err-str )
    {
        { [ dup empty? ] [ drop "no data" ] }
        { [ dup length 6 = not ] [ drop "invalid length" ] }
        [ drop "invalid char(s)" ]
    } cond "*error* " prepend ;

: sedol-valid? ( seq -- ? )
    { [ length 6 = ] [ R/ [0-9BCDFGHJ-NP-TV-Z]+/ matches? ] } 1&& ;

: sedol-value ( m -- n ) dup digit? [ digit> ] [ 55 - ] if ;

: sedol-checksum ( seq -- n )
    [ sedol-value ] { } map-as weights [ * ] 2map sum ;

: (sedol-check-digit) ( seq -- str )
    sedol-checksum 10 mod 10 swap - 10 mod number>string ;

PRIVATE>

: sedol-check-digit ( seq -- str )
    dup sedol-valid? [ (sedol-check-digit) ] [ sedol-error ] if ;

: sedol-demo ( -- )
    "SEDOL   Check digit\n======  ===========" print
    input [ dup sedol-check-digit "%-6s  %s\n" printf ] each ;

MAIN: sedol-demo
