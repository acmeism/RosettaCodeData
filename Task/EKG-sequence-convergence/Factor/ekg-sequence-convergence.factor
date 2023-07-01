USING: combinators.short-circuit formatting fry io kernel lists
lists.lazy math math.statistics prettyprint sequences
sequences.generalizations ;

: ekg? ( n seq -- ? )
    { [ member? not ] [ last gcd nip 1 > ] } 2&& ;

: (ekg) ( seq -- seq' )
    2 lfrom over [ ekg? ] curry lfilter car suffix! ;

: ekg ( n limit -- seq )
    [ 1 ] [ V{ } 2sequence ] [ 2 - [ (ekg) ] times ] tri* ;

: show-ekgs ( seq n -- )
    '[ dup _ ekg "EKG(%d) = %[%d, %]\n" printf ] each ;

: converge-at ( n m max -- o )
    tuck [ ekg [ cum-sum ] [ rest-slice ] bi ] 2bi@
    [ swapd [ = ] 2bi@ and ] 4 nfind 4drop dup [ 2 + ] when ;

{ 2 5 7 9 10 } 20 show-ekgs nl
"EKG(5) and EKG(7) converge at term " write
5 7 100 converge-at .
