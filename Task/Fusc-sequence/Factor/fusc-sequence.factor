USING: arrays assocs formatting io kernel make math math.parser
math.ranges namespaces prettyprint sequences
tools.memory.private ;
IN: rosetta-code.fusc

<PRIVATE

: (fusc) ( n -- seq )
    [ 2 ] dip [a,b) [
        0 , 1 , [
            [ building get ] dip dup even?
            [ 2/ swap nth ]
            [ [ 1 - 2/ ] [ 1 + 2/ ] 2bi [ swap nth ] 2bi@ + ]
            if ,
        ] each
    ] { } make ;

: increases ( seq -- assoc )
    [ 0 ] dip [
        [
            2array 2dup first number>string length <
            [ [ 1 + ] [ , ] bi* ] [ drop ] if
        ] each-index
    ] { } make nip ;

PRIVATE>

: fusc ( n -- seq )
    dup 3 < [ { 0 1 } swap head ] [ (fusc) ] if ;

: fusc-demo ( -- )
    "First 61 fusc numbers:" print 61 fusc [ pprint bl ] each
    nl nl
    "Fusc numbers with more digits than all previous ones:"
    print "Value   Index\n======  =======" print
    1,000,000 fusc increases
   [ [ commas ] bi@ "%-6s  %-7s\n" printf ] assoc-each ;

MAIN: fusc-demo
