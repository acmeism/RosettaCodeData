USE: locals
10 <iota> >vector [| v |
    v [ even? ] filter drop
    v pprint " after filter" print
    v [ even? ] filter! drop
    v pprint " after filter!" print
] call
! V{ 0 1 2 3 4 5 6 7 8 9 } after filter
! V{ 0 2 4 6 8 } after filter!
