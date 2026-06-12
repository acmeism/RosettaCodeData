USING: assocs grouping math prettyprint sequences ;

: max-diff ( seq -- assoc )
    2 clump [ first2 - abs ] collect-by >alist supremum ;

{ 1 8 2 -3 0 1 1 -2.3 0 5.5 8 6 2 9 11 10 3 } max-diff .
