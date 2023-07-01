USING: combinators.short-circuit io kernel lists lists.lazy
locals math math.primes.factors prettyprint sequences ;
IN: rosetta-code.weird-numbers

:: has-sum? ( n seq -- ? )
    seq [ f ] [
        unclip-slice :> ( xs x )
        n x < [ n xs has-sum? ] [
            {
                [ n x = ]
                [ n x - xs has-sum? ]
                [ n xs has-sum? ]
            } 0||
        ] if
    ] if-empty ;

: weird? ( n -- ? )
    dup divisors but-last reverse
    { [ sum < ] [ has-sum? not ] } 2&& ;

: weirds ( -- list ) 1 lfrom [ weird? ] lfilter ;

: weird-numbers-demo ( -- )
    "First 25 weird numbers:" print
    25 weirds ltake list>array . ;

MAIN: weird-numbers-demo
