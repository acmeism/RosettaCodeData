USING: io kernel lists lists.lazy math prettyprint ;

: lsylvester ( -- list ) 2 [ dup sq swap - 1 + ] lfrom-by ;

"First 10 elements of Sylvester's sequence:" print
10 lsylvester ltake dup [ . ] leach nl

"Sum of the reciprocals of first 10 elements:" print
0 [ recip + ] foldl .
