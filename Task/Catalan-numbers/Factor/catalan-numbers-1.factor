USING: kernel math math.combinatorics prettyprint ;

: catalan ( n -- n ) [ 1 + recip ] [ 2 * ] [ nCk * ] tri ;

15 [ catalan . ] each-integer
