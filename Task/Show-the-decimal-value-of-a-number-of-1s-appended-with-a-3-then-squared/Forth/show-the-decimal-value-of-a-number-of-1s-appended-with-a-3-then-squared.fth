: 1s+3
    0 swap
    begin dup while
        swap 10 * 1+ swap 1-
    repeat
    drop 10 * 3 +
;

: sqr dup * ;
: show dup . ." ^2 = " sqr . cr ;

: show-upto
    0 swap
    begin over over < while
        swap dup 1s+3 show 1+ swap
    repeat
    2drop
;

8 show-upto
bye
