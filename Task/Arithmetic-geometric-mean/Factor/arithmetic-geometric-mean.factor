USING: kernel math math.functions prettyprint ;
IN: rosetta-code.arithmetic-geometric-mean

: agm ( a g -- a' g' ) 2dup [ + 0.5 * ] 2dip * sqrt ;

1 1 2 sqrt / [ 2dup - 1e-15 > ] [ agm ] while drop .
