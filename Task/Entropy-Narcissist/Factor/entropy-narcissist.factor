USING: assocs io io.encodings.utf8 io.files kernel math
math.functions math.statistics prettyprint sequences ;
IN: rosetta-code.entropy-narcissist

: entropy ( seq -- entropy )
    [ length ] [ histogram >alist [ second ] map ] bi
    [ swap / ] with map
    [ dup log 2 log / * ] map-sum neg ;

"entropy-narcissist.factor" utf8 [
    contents entropy .
] with-file-reader
