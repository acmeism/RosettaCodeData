USING: grouping io kernel math.ranges math.statistics
math.text.utils math.vectors prettyprint sequences ;

: strange? ( n -- ? )
    1 digit-groups differences vabs
    [ { 2 3 5 7 } member? ] all? ;

"Strange numbers in (100, 500):" print nl
100 500 (a,b) [ strange? ] filter dup
10 group [ [ pprint bl ] each nl ] each nl
length pprint " strange numbers found." print
