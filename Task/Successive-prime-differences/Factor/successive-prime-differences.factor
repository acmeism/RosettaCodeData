USING: formatting fry grouping kernel math math.primes
math.statistics sequences ;
IN: rosetta-code.successive-prime-differences

: seq-diff ( seq diffs -- seq' quot )
    dup [ length 1 + <clumps> ] dip '[ differences _ sequence= ]
    ; inline

: show ( seq diffs -- )
    [ "...for differences %u:\n" printf ] keep seq-diff
    [ find nip { } like ]
    [ find-last nip { } like ]
    [ count ] 2tri
    "First group: %u\nLast group: %u\nCount: %d\n\n" printf ;

: successive-prime-differences ( -- )
    "Groups of successive primes up to one million...\n" printf
    1,000,000 primes-upto {
        { 2 }
        { 1 }
        { 2 2 }
        { 2 4 }
        { 4 2 }
        { 6 4 2 }
    } [ show ] with each ;

MAIN: successive-prime-differences
