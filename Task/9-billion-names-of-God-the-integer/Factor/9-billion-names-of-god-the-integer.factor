USING: combinators io kernel math math.ranges memoize prettyprint
sequences ;

MEMO: p ( m n -- o )
    {
        { [ dup zero? ] [ nip ] }
        { [ 2dup = ] [ 2drop 1 ] }
        { [ 2dup < ] [ 2drop 0 ] }
        [ [ [ 1 - ] bi@ p ] [ [ - ] [ ] bi p + ] 2bi ]
    } cond ;

: row ( n -- seq ) dup [1,b] [ p ] with map ;

: .row ( n -- ) row [ pprint bl ] each nl ;

: .triangle ( n -- ) [1,b] [ .row ] each ;

: G ( n -- sum ) row sum ;

25 .triangle nl
"Sums:" print { 23 123 1234 12345 } [ dup pprint bl G . ] each
