USING: io kernel math.matrices math.order math.ranges
math.statistics math.vectors random sequences strings ;

CHAR: X -15 15 [a,b] dup cartesian-product concat
[ sum-of-squares 100 225 between? ] filter 100 sample
[ 15 v+n ] map 31 31 32 <matrix> [ matrix-set-nths ] keep
[ >string print ] each
