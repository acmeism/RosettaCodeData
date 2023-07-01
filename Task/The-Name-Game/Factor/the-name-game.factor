USING: ascii combinators interpolate io kernel locals
pair-rocket qw sequences ;
IN: rosetta-code.name-game

: vowel? ( char -- ? ) "AEIOU" member? ;

:: name-game ( Name -- )

    Name first  :> L
    Name >lower :> name! L vowel? [ name rest name! ] unless
    "b"         :> B!
    "f"         :> F!
    "m"         :> M!

    L { CHAR: B => [ "" B! ]
        CHAR: F => [ "" F! ]
        CHAR: M => [ "" M! ] [ drop ] } case

[I ${Name}, ${Name}, bo-${B}${name}
Banana-fana fo-${F}${name}
Fee-fi-mo-${M}${name}
${Name}!I] nl nl ;

qw{ Gary Earl Billy Felix Milton Steve } [ name-game ] each
