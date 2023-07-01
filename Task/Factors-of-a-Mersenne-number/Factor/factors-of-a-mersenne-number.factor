USING: combinators.short-circuit interpolate io kernel locals
math math.bits math.functions math.primes sequences ;
IN: rosetta-code.mersenne-factors

: mod-pow-step ( square bit m -- square' )
    [ [ sq ] [ [ 2 * ] when ] bi* ] dip mod ;

:: mod-pow ( m q -- n )
    1 :> s! m make-bits <reversed>
    [ s swap q mod-pow-step s! ] each s ;

: halt-search? ( m q N -- ? )
    dupd > [
        {
            [ nip 8 mod [ 1 ] [ 7 ] bi [ = ] 2bi@ or ]
            [ mod-pow 1 = ] [ nip prime? ]
        } 2&&
    ] dip or ;

:: find-mersenne-factor ( m -- factor/f )
    1          :> k!
    2 m * 1 +  :> q!                 ! the tentative factor.
    2 m ^ sqrt :> N                  ! upper bound on search.
    [ m q N halt-search? ] [ k 1 + k! 2 k * m * 1 + q! ] until
    q N > f q ? ;

: test-mersenne ( m -- )
    dup find-mersenne-factor
    [ [I M${1} is not prime: factor ${0} found.I] ]
    [ [I No factor found for M${}.I] ] if* nl ;

929 test-mersenne
