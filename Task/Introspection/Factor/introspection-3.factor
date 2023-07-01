USING: assocs formatting kernel math namespaces ;

0 0
global [
    nip dup integer? [ + [ 1 + ] dip ] [ drop ] if
] assoc-each
"There are %d integer variables, the sum is %d\n" printf
