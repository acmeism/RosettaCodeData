USING: combinators.extras continuations eval formatting kernel ;
IN: rosetta-code.nested-exceptions

ERROR: U0 ;
ERROR: U1 ;

: baz ( -- )
    "IN: rosetta-code.nested-exceptions : baz ( -- ) U1 ;"
    ( -- ) eval U0 ;

: bar ( -- ) baz ;

: foo ( -- )
    [
        [ bar ] [
            dup T{ U0 } =
            [ "%u recovered\n" printf ] [ rethrow ] if
        ] recover
    ] twice ;

foo
