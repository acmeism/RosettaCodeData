USING: formatting io kernel lists lists.lazy math math.functions
math.primes.lists sequences ;

: adj-primes ( -- list ) lprimes dup cdr lzip ;

: diff ( pair -- n ) first2 swap - ;

: adj-primes-diff ( -- list )
    adj-primes [ dup diff suffix ] lmap-lazy ;

: big-adj-primes-diff ( -- list )
    adj-primes-diff [ last 36 > ] lfilter ;

: square? ( n -- ? ) sqrt dup >integer number= ;

: big-sq-adj-primes-diff ( -- list )
    big-adj-primes-diff [ last square? ] lfilter ;

"Adjacent primes under a million whose difference is a square > 36:" print nl
"p1       p2       difference" print
"============================" print
big-sq-adj-primes-diff [ second 1,000,000 < ] lwhile
[ "%-6d   %-6d   %d\n" vprintf ] leach
