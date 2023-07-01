USING: combinators.random io kernel math prettyprint ;

: sleeping ( n -- heads wakenings )
    0 0 rot [ 1 + .5 [ [ 1 + ] dip ] [ 1 + ] ifp ] times ;

"Wakenings over 1,000,000 experiments: " write
1e6 sleeping dup . /f
"Sleeping Beauty should estimate a credence of: " write .
