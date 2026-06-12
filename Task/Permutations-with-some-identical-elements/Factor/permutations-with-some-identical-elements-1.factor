USING: arrays grouping math math.combinatorics prettyprint
sequences sets ;

: distinct-permutations ( seq -- seq )
    [ CHAR: A + <array> ] map-index "" concat-as <permutations>
    members ;

{ 2 3 1 } distinct-permutations 10 group simple-table.
