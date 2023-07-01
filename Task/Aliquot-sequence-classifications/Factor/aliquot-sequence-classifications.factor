USING: combinators combinators.short-circuit formatting kernel
literals locals math math.functions math.primes.factors
math.ranges namespaces pair-rocket sequences sets ;
FROM: namespaces => set ;
IN: rosetta-code.aliquot

SYMBOL: terms
CONSTANT: 2^47 $[ 2 47 ^ ]
CONSTANT: test-cases {
    11 12 28 496 220 1184 12496 1264460 790
    909 562 1064 1488 15355717786080
}

: next-term ( n -- m ) dup divisors sum swap - ;

: continue-aliquot? ( hs term -- hs term ? )
    {
        [ terms get 15 < ]
        [ swap in? not   ]
        [ nip zero? not  ]
        [ nip 2^47 <     ]
    } 2&& ;

: next-aliquot ( hs term -- hs next-term term )
    [ swap [ adjoin    ] keep ]
    [ dup  [ next-term ] dip  ] bi terms inc ;

: aliquot ( k -- seq )
    0 terms set HS{ } clone swap
    [ continue-aliquot? ] [ next-aliquot ] produce
    [ drop ] 2dip swap suffix ;

: non-terminating? ( seq -- ? )
    { [ length 15 > ] [ [ 2^47 > ] any? ] } 1|| ;

:: classify ( seq -- classification-str )
    {
        [ seq non-terminating? ] => [ "non-terminating" ]
        [ seq last zero?       ] => [ "terminating"     ]
        [ seq length 2 =       ] => [ "perfect"         ]
        [ seq length 3 =       ] => [ "amicable"        ]
        [ seq first seq last = ] => [ "sociable"        ]
        [ seq 2 tail* first2 = ] => [ "aspiring"        ]
        [ "cyclic" ]
    } cond ;

: .classify ( k -- )
    dup aliquot [ classify ] keep "%14u: %15s: %[%d, %]\n"
    printf ;

: main ( -- )
    10 [1,b] test-cases append [ .classify ] each ;

MAIN: main
