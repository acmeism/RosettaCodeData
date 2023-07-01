USING: io kernel locals math prettyprint sequences ;

[let
    ! Create a sequence of 10 quotations
    10 iota [
        :> i            ! Bind lexical variable i
        [ i i * ]       ! Push a quotation to calculate i squared
    ] map :> seq

    { 3 8 } [
        dup pprint " squared is " write
        seq nth call .
    ] each
]
