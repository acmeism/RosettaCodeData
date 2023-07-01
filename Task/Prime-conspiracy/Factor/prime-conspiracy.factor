USING: assocs formatting grouping kernel math math.primes math.statistics
sequences sorting ;
IN: rosetta-code.prime-conspiracy

: transitions ( n -- alist )
    nprimes [ 10 mod ] map 2 clump histogram >alist natural-sort ;

: t-values ( transition -- i j count freq )
    first2 [ first2 ] dip dup 10000. / ;

: print-trans ( transition -- )
    t-values "%d -> %d  count: %5d  frequency: %5.2f%%\n" printf ;

: header ( n -- )
    "First %d primes. Transitions prime %% 10 -> next-prime %% 10.\n" printf ;

: main ( -- )
    1,000,000 dup header transitions [ print-trans ] each ;

MAIN: main
