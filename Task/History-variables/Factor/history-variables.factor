USING: accessors combinators formatting kernel models.history ;

1 <history> {
    [ add-history ]
    [ value>> "Initial value: %u\n" printf ]
    [ 2 >>value add-history ]
    [ 3 swap value<< ]
    [ value>> "Current value: %u\n" printf ]
    [ go-back ]
    [ go-back ]
    [ value>> "Restored value: %u\n" printf ]
} cleave
