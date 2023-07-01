USING: formatting io kernel math math.parser sequences ;

: print-menu ( seq -- )
    [ 1 + swap "%d - %s\n" printf ] each-index
    "Your choice? " write flush ;

: (select) ( seq -- result )
    dup print-menu readln string>number dup integer? [
        drop 1 - swap 2dup bounds-check?
        [ nth ] [ nip (select) ] if
    ] [ drop (select) ] if* ;

: select ( seq -- result ) [ "" ] [ (select) ] if-empty ;
