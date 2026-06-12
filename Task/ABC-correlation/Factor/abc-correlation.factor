USING: assocs grouping kernel math.statistics sequences ;

: abc? ( str -- ? )
    histogram "abc" [ of ] with { } map-as all-eq? ;
