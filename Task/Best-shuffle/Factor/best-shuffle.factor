USING: arrays combinators.short-circuit formatting kernel random
sequences sequences.extras ;

:: best-shuffle ( str -- str' )
    str clone :> new-str
    str length :> n
    n <iota> >array randomize :> range1
    n <iota> >array randomize :> range2

    range1 [| i |
        range2 [| j |
            {
                [ i j = ]
                [ i new-str nth j new-str nth = ]
                [ i str nth j new-str nth = ]
                [ i new-str nth j str nth = ]
            } 0|| [
                 i j new-str exchange
            ] unless
        ] each
    ] each

    new-str ;

: best-shuffle. ( str -- )
    dup best-shuffle 2dup [ = ] 2count "%s, %s, (%d)\n" printf ;
