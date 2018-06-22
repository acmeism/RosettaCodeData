USING: combinators.short-circuit.smart io prettyprint ;
IN: rosetta-code.short-circuit

: a ( ? -- ? ) "(a)" write ;
: b ( ? -- ? ) "(b)" write ;

"f && f = " write { [ f a ] [ f b ] } && .
"f || f = " write { [ f a ] [ f b ] } || .
"f && t = " write { [ f a ] [ t b ] } && .
"f || t = " write { [ f a ] [ t b ] } || .
"t && f = " write { [ t a ] [ f b ] } && .
"t || f = " write { [ t a ] [ f b ] } || .
"t && t = " write { [ t a ] [ t b ] } && .
"t || t = " write { [ t a ] [ t b ] } || .
