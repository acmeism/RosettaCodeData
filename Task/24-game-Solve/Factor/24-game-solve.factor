USING: continuations grouping io kernel math math.combinatorics
prettyprint quotations random sequences sequences.deep ;
IN: rosetta-code.24-game

: 4digits ( -- seq ) 4 9 random-integers [ 1 + ] map ;

: expressions ( digits -- exprs )
    all-permutations [ [ + - * / ] 3 selections
    [ append ] with map ] map flatten 7 group ;

: 24= ( exprs -- )
    >quotation dup call( -- x ) 24 = [ . ] [ drop ] if ;

: 24-game ( -- )
    4digits dup "The numbers: " write . "The solutions: "
    print expressions [ [ 24= ] [ 2drop ] recover ] each ;

24-game
