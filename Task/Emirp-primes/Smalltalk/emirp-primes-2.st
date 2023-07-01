primeGen :=
    [:n |
        LazyCons car:n cdr:[primeGen value:(n nextPrime)]
    ].
