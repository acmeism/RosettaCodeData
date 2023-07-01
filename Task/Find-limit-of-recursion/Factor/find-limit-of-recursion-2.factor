SYMBOL: depth

: fn ( n -- n ) depth inc 1 + fn 1 + ;

[ 0 fn ] try
depth get "Recursion depth on this system is %d.\n" printf
