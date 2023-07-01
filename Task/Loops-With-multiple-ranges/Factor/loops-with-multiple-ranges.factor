USING: formatting kernel locals math math.functions math.ranges
sequences sequences.generalizations tools.memory.private ;

[let                            ! Allow lexical variables.
     1 :> prod!                 ! Start with a product of unity.
     0 :> sum!                  !   "     "  "   sum    " zero.
     5 :> x
    -5 :> y
    -2 :> z
     1 :> one
     3 :> three
     7 :> seven

    three neg 3 3 ^ three <range>              ! Create array
    seven neg seven x     <range>              ! of 7 ranges.
    555 550 y -             [a,b]
    22 -28 three neg      <range>
    1927 1939               [a,b]
    x y z                 <range>
    11 x ^ 11 x ^ 1 +       [a,b] 7 narray

    [
        [
            :> j j abs sum + sum!
            prod abs 2 27 ^ < j zero? not and
            [ prod j * prod! ] when
        ] each                      ! Loop over range.
    ] each                          ! Loop over array of ranges.

    ! SUM and PROD are used for verification of J incrementation.
    sum prod [ commas ] bi@ " sum=  %s\nprod= %s\n" printf
]
