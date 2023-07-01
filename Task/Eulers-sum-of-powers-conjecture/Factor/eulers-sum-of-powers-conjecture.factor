USING: arrays backtrack kernel literals math.functions
math.ranges prettyprint sequences ;

CONSTANT: pow5 $[ 0 250 [a,b) [ 5 ^ ] map ]

: xn ( n1 -- n2 n2 ) [1,b) amb-lazy dup ;

250 xn xn xn xn drop 4array dup pow5 nths sum dup pow5
member? [ pow5 index suffix . ] [ 2drop fail ] if
