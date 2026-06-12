USING: formatting grouping io kernel math sequences sets ;

: unique-substrings ( seq n -- newseq )
    tuck <clumps> [ cardinality = ] with filter ;

: longest-unique-substring ( seq -- newseq )
    dup length { } [ 2dup empty? swap 0 > and ]
    [ drop 2dup unique-substrings [ 1 - ] dip ] while
    2nip [ "" like ] map members ;

: test ( seq -- )
    dup longest-unique-substring "%u -> %u\n" printf ;

"Longest substrings without repeating characters:" print
{ "xyzyabcybdfd" "xyzyab" "zzzzz" "a" "" } [ test ] each
