: squared ( n -- n' )  dup * ;
: doors ( n -- )
    1 begin 2dup squared >= while
        dup squared .
    1+ repeat 2drop ;
100 doors
