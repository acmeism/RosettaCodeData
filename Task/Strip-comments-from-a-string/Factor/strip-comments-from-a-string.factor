USE: sequences.extras
: strip-comments ( str -- str' )
    [ "#;" member? not ] take-while "" like ;
