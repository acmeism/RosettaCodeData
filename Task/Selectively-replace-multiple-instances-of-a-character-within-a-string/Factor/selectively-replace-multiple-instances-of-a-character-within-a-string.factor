USING: assocs formatting grouping kernel random sequences ;

CONSTANT: instrs {
    CHAR: a 1 CHAR: A
    CHAR: a 2 CHAR: B
    CHAR: a 4 CHAR: C
    CHAR: a 5 CHAR: D
    CHAR: b 1 CHAR: E
    CHAR: r 2 CHAR: F
}

: counts ( seq -- assoc )
    H{ } clone swap [ 2dup swap inc-at dupd of ] zip-with nip ;

: replace-nths ( seq instrs -- seq' )
    [ counts ] dip 3 group [ f suffix 2 group ] map substitute keys ;

: test ( str -- )
    dup instrs replace-nths "" like "%s -> %s\n" printf ;


"abracadabra" test
"abracadabra" randomize test
