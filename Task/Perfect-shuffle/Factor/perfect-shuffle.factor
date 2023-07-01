USING: arrays formatting kernel math prettyprint sequences
sequences.merged ;
IN: rosetta-code.perfect-shuffle

CONSTANT: test-cases { 8 24 52 100 1020 1024 10000 }

: shuffle ( seq -- seq' ) halves 2merge ;

: shuffle-count ( n -- m )
    <iota> >array 0 swap dup [ 2dup = ] [ shuffle [ 1 + ] 2dip ]
    do until 2drop ;

"Deck size" "Number of shuffles required" "%-11s %-11s\n" printf
test-cases [ dup shuffle-count "%-11d %-11d\n" printf ] each
