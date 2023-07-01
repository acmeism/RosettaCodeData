USING: io kernel math math.order present prettyprint sequences
typed ;

ALIAS: ⊕ max
ALIAS: ⊗ +
PREDICATE: posint < integer 0 > ;
TYPED: ↑ ( x: real n: posint -- y: real ) * ;

: show ( quot -- )
    dup present rest but-last "⟶ " append write call . ; inline

{
    [ 2 -2 ⊗ ]
    [ -0.001 -1/0. ⊕ ]
    [ 0 -1/0. ⊗ ]
    [ 1.5 -1 ⊕ ]
    [ -0.5 0 ⊗ ]
    [ 5 7 ↑ ]
    [ 8 7 ⊕ 5 ⊗ ]
    [ 5 8 ⊗ 5 7 ⊗ ⊕ ]
    [ 8 7 ⊕ 5 ⊗   5 8 ⊗ 5 7 ⊗ ⊕   = ]
} [ show ] each
