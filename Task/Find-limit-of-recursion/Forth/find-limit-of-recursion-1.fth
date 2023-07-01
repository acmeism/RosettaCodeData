: munge ( n -- n' ) 1+ recurse ;

: test   0 ['] munge catch if ." Recursion limit at depth " . then ;

test   \ Default gforth: Recursion limit at depth 3817
