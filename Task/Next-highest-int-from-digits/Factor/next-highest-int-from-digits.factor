USING: formatting grouping kernel math math.combinatorics
math.parser sequences ;

: next-highest ( m -- n )
    number>string dup [ >= ] monotonic?
    [ drop 0 ] [ next-permutation string>number ] if ;

{
    0 9 12 21 12453 738440 45072010 95322020
    9589776899767587796600
}
[ dup next-highest "%d -> %d\n" printf ] each
