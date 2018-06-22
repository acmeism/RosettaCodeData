USING: continuations formatting io kernel math.ranges
prettyprint random sequences ;
IN: rosetta-code.loops-nested

: rand-table ( -- seq )
    10 [ 20 [ 20 [1,b] random ] replicate ] replicate ;

rand-table [
    [ [ dup "%4d" printf 20 = [ return ] when ] each nl ] each
] with-return drop
