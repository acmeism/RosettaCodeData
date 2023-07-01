USING: kernel math math.combinatorics math.extras math.functions
math.ranges prettyprint sequences ;

: faulhaber ( p -- seq )
    1 + dup recip swap dup 0 (a,b]
    [ [ nCk ] [ -1 swap ^ ] [ bernoulli ] tri * * * ] 2with map ;

10 [ faulhaber . ] each-integer
