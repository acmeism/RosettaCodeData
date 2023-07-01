USING: assocs assocs.extras formatting io kernel math
math.functions math.statistics random sequences
tools.memory.private ;

: modifier ( x -- y ) 0.5 over 0.5 < [ swap ] when - dup + ;

: random-unit-by ( quot: ( x -- y ) -- z )
    random-unit dup pick call random-unit 2dup >
    [ 2drop nip ] [ 3drop random-unit-by ] if ; inline recursive

: data ( n quot bins -- histogram )
    '[ _ random-unit-by _ * >integer ] replicate histogram ;
    inline

:: .histogram ( h -- )

    h assoc-size :> buckets   ! number of buckets
    h sum-values :> total     ! items in histogram
    h values supremum :> max  ! largest bucket (as in most occurrences)
    40 :> size                ! max size of a bar

    total commas buckets
    "Bin          Histogram (%s items, %d buckets)\n" printf

    h [| k v |
        k buckets / dup buckets recip + "[%.2f, %.2f) " printf
        size v * max / ceiling
        [ "▇" write ] times bl bl v commas print
    ] assoc-each ;

"Modified random distribution of values in [0, 1):" print nl
100,000 [ modifier ] 20 data .histogram
