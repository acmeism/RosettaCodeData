: sum< ( run-time: hi+1 lo -- 0e )
    0e0 postpone fliteral postpone ?do ; immediate

: >sum ( run-time: r1 r2 -- r3 )
    postpone f+ postpone loop ; immediate

: main ( -- )
    101 1 sum< 1e0 i s>f f/ >sum f. ;
main
