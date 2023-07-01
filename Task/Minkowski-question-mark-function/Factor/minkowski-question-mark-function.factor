USING: formatting kernel make math math.constants
math.continued-fractions math.functions math.parser
math.statistics sequences sequences.extras splitting.monotonic
vectors ;

CONSTANT: max-iter 151

: >continued-fraction ( x -- seq )
    0 swap 1vector
    [ dup last integer? pick max-iter > or ]
    [ dup next-approx [ 1 + ] dip ] until nip
    dup last integer? [ but-last-slice ] unless ;

: ? ( x -- y )
    >continued-fraction unclip swap cum-sum
    [ max-iter < ] take-while
    [ even? 1 -1 kernel:? swap 2^ / ] map-index
    sum 2 * + >float ;

: (float>bin) ( x -- y )
    [ dup 0 > ]
    [ 2 * dup >integer # dup 1 >= [ 1 - ] when ] while ;

: float>bin ( x -- n str )
    >float dup >integer [ - ] keep swap abs
    [ 0 # (float>bin) ] "" make nip ;

: ?⁻¹ ( x -- y )
    dup float>bin [ = ] monotonic-split
    [ length ] map swap prefix >ratio swap copysign ;

: compare ( x y -- ) "%-25u%-25u\n" printf ;

phi ? 5 3 /f compare
-5/9 ?⁻¹ 13 sqrt 7 - 6 /f compare
0.718281828 ?⁻¹ ? 0.1213141516171819 ? ?⁻¹ compare
