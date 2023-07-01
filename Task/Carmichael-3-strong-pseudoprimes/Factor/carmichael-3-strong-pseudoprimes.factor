USING: formatting kernel locals math math.primes math.ranges
sequences ;
IN: rosetta-code.carmichael

:: carmichael ( p1 -- )
    1 p1 (a,b) [| h3 |
        h3 p1 + [1,b) [| d |
            h3 p1 + p1 1 - * d mod zero?
            p1 neg p1 * h3 rem d h3 mod = and
            [
                p1 1 - h3 p1 + * d /i 1 +  :> p2
                p1 p2 * h3 /i 1 +          :> p3
                p2 p3 [ prime? ] both?
                p2 p3 * p1 1 - mod 1 = and
                [ p1 p2 p3 "%d %d %d\n" printf ] when
            ] when
        ] each
    ] each
;

: carmichael-demo ( -- ) 61 primes-upto [ carmichael ] each ;

MAIN: carmichael-demo
