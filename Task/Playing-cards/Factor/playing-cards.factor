USING: formatting grouping io kernel math qw random sequences
vectors ;
IN: rosetta-code.playing-cards

CONSTANT: pips  qw{ A 2 3 4 5 6 7 8 9 10 J Q K }
CONSTANT: suits qw{ ♥ ♣ ♦ ♠ }

: <deck> ( -- vec ) 52 <iota> >vector ;

: card>str ( n -- str )
    13 /mod [ suits nth ] [ pips nth ] bi* prepend ;

: print-deck ( seq -- )
    13 group [ [ card>str "%-4s" printf ] each nl ] each ;

<deck>       ! make new deck
randomize    ! shuffle the deck
dup pop drop ! deal from the deck (and discard)
print-deck   ! print the deck
