USING: formatting io kernel lists lists.lazy math math.ranges
math.vectors numspec present prettyprint sequences sets ;

: multiples ( n -- seq )
    [ 2 * ] [ 6 * ] [ ] tri <range> [ present ] map ;

: all-set-eq? ( seq -- ? )
    dup ?first [ set= ] curry all? ;

! Ordered lazy list of numbers that start with a '1' digit
NUMSPEC: starting-with-one 1 1_ ... ;

: smallest-permuted-multiple ( -- n )
    starting-with-one [ multiples all-set-eq? ] lfilter car ;

{ 2 3 4 5 6 } " n: " write smallest-permuted-multiple dup .
over n*v [ "×%d: %d\n" printf ] 2each
