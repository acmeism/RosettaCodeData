USING: grouping math.primes.factors math.ranges ;

: pdivs      ( n -- seq )   divisors but-last ;
: dsum       ( n -- sum )   pdivs sum ;
: dsum=      ( n m -- ? )   dsum = ;
: both-dsum= ( n m -- ? )   [ dsum= ] [ swap dsum= ] 2bi and ;
: amicable?  ( n m -- ? )   [ both-dsum= ] [ = not ] 2bi and ;
: drange     ( -- seq )     2 20000 [a,b) ;
: dsums      ( -- seq )     drange [ dsum ] map ;
: is-am?-seq ( -- seq )     dsums drange [ amicable? ] 2map ;
: am-nums    ( -- seq )     t is-am?-seq indices ;
: am-nums-c  ( -- seq )     am-nums [ 2 + ] map ;
: am-pairs   ( -- seq )     am-nums-c 2 group ;
: print-am   ( -- )         am-pairs [ >array . ] each ;

print-am
