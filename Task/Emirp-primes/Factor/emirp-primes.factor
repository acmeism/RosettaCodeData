USING: io kernel lists lists.lazy math.extras math.parser
    math.primes sequences ;
FROM: prettyprint => . pprint ;
IN: rosetta-code.emirp

: rev ( n -- n' )
    number>string reverse string>number ;

: emirp? ( n -- ? )
    dup rev [ = not ] [ [ prime? ] bi@ ] 2bi and and ;

: nemirps ( n -- seq )
    0 lfrom [ emirp? ] lfilter ltake list>array ;

: print-seq ( seq -- )
    [ pprint bl ] each nl ;

: part1 ( -- )
    "First 20 emirps:" print 20 nemirps print-seq ;

: part2 ( -- )
    "Emirps between 7700 and 8000:" print
    7700 ... 8000 [ emirp? ] filter print-seq ;

: part3 ( -- )
    "10,000th emirp:" print 10,000 nemirps last . ;

: main ( -- )
    part1 nl part2 nl part3 ;

MAIN: main
