: recur; [ last 2 cells + literal ] @ +bal postpone again ; immediate

: test dup if 1+ recur; then drop ." I gave up finding a limit!" ;

1 test
