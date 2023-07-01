USING: assocs formatting grouping io kernel math math.bits
math.combinatorics sequences sequences.extras ;

: make-rules ( n -- assoc )
    { f t } 3 selections swap make-bits 8 f pad-tail zip ;

: next-state ( assoc seq -- assoc seq' )
    dupd 3 circular-clump -1 rotate [ of ] with map ;

: first-state ( -- seq ) 15 f <repetition> dup { t } glue ;

: show-state ( seq -- ) [ "#" "." ? write ] each nl ;

: show-automaton ( rule -- )
    dup "Rule %d:\n" printf make-rules first-state 16
    [ dup show-state next-state ] times 2drop ;

90 show-automaton
