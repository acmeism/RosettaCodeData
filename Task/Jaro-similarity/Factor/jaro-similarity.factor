USING: formatting fry generalizations kernel locals make math
math.order sequences sequences.extras ;
IN: rosetta-code.jaro-distance

: match? ( s1 s2 n -- ? )
    [ pick nth swap indices nip ] [ 2nip ]
    [ drop [ length ] bi@ max 2/ 1 - ] 3tri
    '[ _ - abs _ <= ] any? ;

: matches ( s1 s2 -- seq )
    over length <iota> [
        [ [ nip swap nth ] [ match? ] 3bi [ , ] [ drop ] if ]
        2with each
    ] "" make ;

: transpositions ( s1 s2 -- n )
    2dup swap [ matches ] 2bi@ [ = not ] 2count 2/ ;

:: jaro ( s1 s2 -- x )
    s1 s2 matches length :> m
    s1 length            :> |s1|
    s2 length            :> |s2|
    s1 s2 transpositions :> t
    m zero? [ 0 ] [ m |s1| / m |s2| / m t - m / + + 1/3 * ] if ;

: jaro-demo ( -- )
    "DWAYNE" "DUANE"
    "MARTHA" "MARHTA"
    "DIXON" "DICKSONX"
    "JELLYFISH" "SMELLYFISH" [
        2dup jaro dup >float "%u %u jaro -> %u (~%.5f)\n" printf
    ] 2 4 mnapply ;

MAIN: jaro-demo
