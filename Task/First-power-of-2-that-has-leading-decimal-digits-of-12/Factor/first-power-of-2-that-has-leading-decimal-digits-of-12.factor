USING: formatting fry generalizations kernel literals math
math.functions math.parser sequences tools.time ;

CONSTANT: ld10 $[ 2 log 10 log / ]

: p ( L n -- m )
    swap [ 0 0 ]
    [ '[ over _ >= ] ]
    [ [ log10 >integer 10^ ] keep ] tri*
    '[
        1 + dup ld10 * dup >integer - 10 log * e^ _ * truncate
        _ number= [ [ 1 + ] dip ] when
    ] until nip ;

[
    12 1
    12 2
    123 45
    123 12345
    123 678910
    [ 2dup p "%d %d p = %d\n" printf ] 2 5 mnapply
] time
