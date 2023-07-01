USING: compiler.tree.propagation.call-effect io kernel math
math.ranges prettyprint sequences ;

: padn ( m n -- seq )
    V{ "|" 1 1 1 } over prefix clone over 2 -
    [ dup last2 + suffix! ] times rot pick 1 + -
    [ dup length 1 - pick [ - ] keepd pick <slice> sum suffix! ]
    times nip ;

"Padovan n-step sequences" print
2 8 [a..b] [ 15 swap padn ] map simple-table.
