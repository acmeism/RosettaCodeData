USING: io kernel literals math math.extras prettyprint sequences ;

CONSTANT: epsilon $[ 1.0 [ dup 1 + 1 number= ] [ 2 /f ] until ]

${ 1.0 epsilon dup neg }
[ "Left associative: " write sum . ]
[ "Kahan summation:  " write kahan-sum . ] bi
"Epsilon:          " write epsilon .
