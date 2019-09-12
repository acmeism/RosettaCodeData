: disjoint-sort ( values indices -- seq )
    over <enumerated> nths unzip swap [ natural-sort ] bi@
    pick [ set-nth ] curry 2each ;
