: square dup * ;
: cube dup dup * * ;
: 30-non-cube-squares
    0 1 1
    begin 2 pick 30 < while
        begin over over square swap cube > while
            swap 1+ swap
        repeat
        over over square swap cube <> if
            dup square . rot 1+ -rot
        then
        1+
    repeat
    2drop drop
;

30-non-cube-squares cr bye
