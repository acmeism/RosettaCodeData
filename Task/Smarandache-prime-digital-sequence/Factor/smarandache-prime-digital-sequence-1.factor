USING: combinators.short-circuit io lists lists.lazy math
math.parser math.primes prettyprint sequences ;
IN: rosetta-code.smarandache-naive

: smarandache? ( n -- ? )
    {
        [ number>string string>digits [ prime? ] all? ]
        [ prime? ]
    } 1&& ;

: smarandache ( -- list ) 1 lfrom [ smarandache? ] lfilter ;

: smarandache-demo ( -- )
    "First 25 members of the Smarandache prime-digital sequence:"
    print 25 smarandache ltake list>array .
    "100th member: " write smarandache 99 [ cdr ] times car . ;

MAIN: smarandache-demo
