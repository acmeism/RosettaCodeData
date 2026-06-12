USING: combinators formatting io kernel locals math sequences ;

! highest power of 2 that divides a given number
: hpo2 ( n -- n ) dup neg bitand ;

! base 2 logarithm of the highest power of 2 dividing a given number
: lhpo2 ( n -- n )
    hpo2 0 swap [ dup even? ] [ -1 shift [ 1 + ] dip ] while drop ;

! nim sum of two numbers
ALIAS: nim-sum bitxor

! nim product of two numbers
:: nim-prod ( x y -- prod )
    x hpo2 :> h!
    0 :> comp!
    {
        { [ x 2 < y 2 < or ] [ x y * ] }
        { [ x h > ] [ h y nim-prod x h bitxor y nim-prod bitxor ] }   ! recursively break x into its powers of 2
        { [ y hpo2 y < ] [ y x nim-prod ] }                           ! recursively break y into its powers of 2 by flipping the operands
        { [ x y [ lhpo2 ] bi@ bitand comp! comp zero? ] [ x y * ] }   ! we have no fermat power in common
        [
            comp hpo2 h!                                              ! a fermat number square is its sequimultiple
            x h neg shift y h neg shift nim-prod
            3 h 1 - shift nim-prod
        ]
    } cond ;

! words for printing tables
: dashes ( n -- ) [ CHAR: - ] "" replicate-as write ;
: top1 ( str -- ) " %s |" printf 16 <iota> [ "%3d" printf ] each nl ;
: top2 ( -- ) 3 dashes bl 49 dashes nl ;

: row ( n quot -- )
    over "%2d |" printf curry 16 <iota> swap
    [ call "%3d" printf ] curry each ; inline

: table ( quot str -- )
    top1 top2 16 <iota> swap [ row nl ] curry each ; inline

! task
[ nim-sum ] "+" table nl
[ nim-prod ] "*" table nl
33333 77777
[ 2dup nim-sum "%d + %d = %d\n" printf ]
[ 2dup nim-prod "%d * %d = %d\n" printf ] 2bi
