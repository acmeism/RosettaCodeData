USING: assocs kernel math math.functions math.statistics
prettyprint sequences ;
IN: rosetta-code.entropy

: shannon-entropy ( str -- entropy )
    [ length ] [ histogram >alist [ second ] map ] bi
    [ swap / ] with map
    [ dup log 2 log / * ] map-sum neg ;

"1223334444" shannon-entropy .
"Factor is my favorite programming language." shannon-entropy .
