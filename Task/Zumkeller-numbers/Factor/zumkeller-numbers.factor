USING: combinators grouping io kernel lists lists.lazy math
math.primes.factors memoize prettyprint sequences ;

MEMO: psum? ( seq n -- ? )
    {
        { [ dup zero? ] [ 2drop t ] }
        { [ over length zero? ] [ 2drop f ] }
        { [ over last over > ] [ [ but-last ] dip psum? ] }
        [
            [ [ but-last ] dip psum? ]
            [ over last - [ but-last ] dip psum? ] 2bi or
        ]
    } cond ;

: zumkeller? ( n -- ? )
    dup divisors dup sum
    {
        { [ dup odd? ] [ 3drop f ] }
        { [ pick odd? ] [ nip swap 2 * - [ 0 > ] [ even? ] bi and ] }
        [ nipd 2/ psum? ]
    } cond ;

: zumkellers ( -- list )
    1 lfrom [ zumkeller? ] lfilter ;

: odd-zumkellers ( -- list )
    1 [ 2 + ] lfrom-by [ zumkeller? ] lfilter ;

: odd-zumkellers-no-5 ( -- list )
    odd-zumkellers [ 5 mod zero? not ] lfilter ;

: show ( count list row-len -- )
    [ ltake list>array ] dip group simple-table. nl ;

"First 220 Zumkeller numbers:" print
220 zumkellers 20 show

"First 40 odd Zumkeller numbers:" print
40 odd-zumkellers 10 show

"First 40 odd Zumkeller numbers not ending with 5:" print
40 odd-zumkellers-no-5 8 show
