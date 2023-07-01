USING: deques dlists formatting fry io kernel locals make math
math.order math.primes math.text.english namespaces prettyprint
sequences tools.memory.private ;
IN: rosetta-code.n-smooth-numbers

SYMBOL: primes

: ns ( n -- seq )
    primes-upto [ primes set ] [ length [ 1 1dlist ] replicate ]
    bi ;

: enqueue ( n seq -- )
    [ primes get ] 2dip [ '[ _ * ] map ] dip [ push-back ] 2each
    ;

: next ( seq -- n )
    dup [ peek-front ] map infimum
    [ '[ dup peek-front _ = [ pop-front* ] [ drop ] if ] each ]
    [ swap enqueue ] [ nip ] 2tri ;

: next-n ( seq n -- seq )
    swap '[ _ [ _ next , ] times ] { } make ;

:: n-smooth ( n from to -- seq )
    n ns to next-n to from - 1 + tail* ;

:: show-smooth ( plo phi lo hi -- )
    plo phi primes-between [
        :> p lo commas lo ordinal-suffix hi commas hi
        ordinal-suffix p "%s%s through %s%s %d-smooth numbers: "
        printf p lo hi n-smooth [ pprint bl ] each nl
    ] each ;

: smooth-numbers-demo ( -- )
    2 29 1 25 show-smooth nl
    3 29 3000 3002 show-smooth nl
    503 521 30,000 30,019 show-smooth ;

MAIN: smooth-numbers-demo
