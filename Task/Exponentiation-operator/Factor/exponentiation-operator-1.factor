: pow ( f n -- f' )
    dup 0 < [ abs pow recip ]
    [ [ 1 ] 2dip swap [ * ] curry times ] if ;
