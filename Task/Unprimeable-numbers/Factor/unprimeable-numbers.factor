USING: assocs formatting io kernel lists lists.lazy
lists.lazy.examples math math.functions math.primes math.ranges
math.text.utils prettyprint sequences tools.memory.private ;

: one-offs ( n -- seq )
    dup 1 digit-groups [
        swapd 10^ [ * ] keep [ - ] dip
        2dup [ 9 * ] [ + ] [ <range> ] tri*
    ] with map-index concat ;

: (unprimeable?) ( n -- ? )
    [ f ] [ one-offs [ prime? ] none? ] if-zero ;

: unprimeable? ( n -- ? )
    dup prime? [ drop f ] [ (unprimeable?) ] if ;

: unprimeables ( -- list ) naturals [ unprimeable? ] lfilter ;

: ?set-at ( value key assoc -- )
    2dup key? [ 3drop ] [ set-at ] if ;

: first-digits ( -- assoc )
    unprimeables H{ } clone [ dup assoc-size 10 = ]
    [ [ unswons dup 10 mod ] dip [ ?set-at ] keep ] until nip ;

"The first 35 unprimeable numbers:" print bl bl
35 unprimeables ltake [ pprint bl ] leach nl nl

"The 600th unprimeable number:" print bl bl
599 unprimeables lnth commas print nl

"The first unprimeable number ending with" print
first-digits [ commas "  %d: %9s\n" printf ] assoc-each
