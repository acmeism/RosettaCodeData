USING: io kernel math math.parser locals qw sequences ;
IN: rosetta-code.nested-functions

:: make-list ( separator -- str )
    1 :> counter!
    [| item |
        counter number>string separator append item append
        counter 1 + counter!
    ] :> make-item
    qw{ first second third } [ make-item call ] map "\n" join
;

". " make-list write
