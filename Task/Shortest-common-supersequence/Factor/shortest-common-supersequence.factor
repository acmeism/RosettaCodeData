USING: combinators io kernel locals math memoize sequences ;

MEMO:: scs ( x y -- seq )
    {
        { [ x empty? ] [ y ] }
        { [ y empty? ] [ x ] }
        { [ x first y first = ]
          [ x rest y rest scs x first prefix ] }
        { [ x y rest scs length x rest y scs length <= ]
          [ x y rest scs y first prefix ] }
        [ x rest y scs x first prefix ]
    } cond ;

"abcbdab" "bdcaba" scs print
