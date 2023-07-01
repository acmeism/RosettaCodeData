USING: math math.statistics ;

: arithmetic-mean ( seq -- n )
    [ 0 ] [ mean ] if-empty ;
