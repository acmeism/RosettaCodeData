USING: combinators.short-circuit fry kernel literals math
math.ranges memoize prettyprint sequences sets tools.time ;
IN: rosetta-code.sum-and-product

CONSTANT: s1 $[
    2 100 [a,b] dup cartesian-product concat
    [ first2 { [ < ] [ + 100 < ] } 2&& ] filter
]

: quot-eq ( pair quot -- seq )
    [ s1 ] 2dip tuck '[ @ _ @ = ] filter ; inline

MEMO: sum-eq ( pair -- seq ) [ first2 + ] quot-eq ;
MEMO: mul-eq ( pair -- seq ) [ first2 * ] quot-eq ;

: s2 ( -- seq )
    s1 [ sum-eq [ mul-eq length 1 = not ] all? ] filter ;

: only-1 ( seq quot -- newseq )
    over '[ @ _ intersect length 1 = ] filter ; inline

: sum-and-product ( -- )
    [ s2 [ mul-eq ] [ sum-eq ] [ only-1 ] bi@ . ] time ;

MAIN: sum-and-product
