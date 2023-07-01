USING: binary-search formatting io kernel math.ranges words ;

: instruct ( -- )
    "Think of a number between 1 and 100." print
    "Score my guess with +lt+ +gt+ or +eq+." print nl ;

: score ( n -- <=> )
    "My guess is %d. " printf readln "math.order" lookup-word ;

: play-game ( -- n )
    100 [1,b] [ score ] search nip nl ;

: gloat ( n -- )
    "I did it. Your number was %d!\n" printf ;

instruct play-game gloat
