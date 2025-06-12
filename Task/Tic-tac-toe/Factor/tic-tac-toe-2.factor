USING: multiline math.vectors arrays sequences io.streams.c kernel assocs math io grouping math.matrices math.parser random strings ; IN: tictactoe

: open? ( pos board -- ? ) nth 0 = ;

: full? ( board -- ? ) 0 swap member? not ;

: won? ( board -- ? )
    3 <groups> dup [ flip ] [ main-diagonal ] [ anti-diagonal ] tri 2array 3append [ sum abs 3 = ] any? ;

: you ( -- position )
    "enter a move (1-9):" print readln string>number 1 - dup
    [ 9 < ] [ 0 >= ] bi and [ drop "no" print you ] unless ;

: cpu ( board -- ? ) [ [ 0 = ] dip and ] map-index sift random ;

: pos ( cturn? board -- position ) swap 0 < [ cpu ] [ drop you ] if ;

: move ( turn board -- nturn nboard )
    2dup pos swap 2dup open? [ [ set-nth ] [ nip ] 3bi [ neg ] dip  ] [ nip "no" print move ] if ;

: show ( board -- )
    nl 3 <groups> [ [ 1 + "O.X" nth 1string " " append write ] each nl ] each ;

: outcome ( turn board -- )
    [ neg ] dip won? [ 1 + "O.X" nth 1string " wins" append ] [ drop "tie" ] if nl print ;

: ttt ( -- ) -1 9 0 <array> [ move [ show ] keep dup [ won? ] [ full? ] bi or not ] loop outcome ;
