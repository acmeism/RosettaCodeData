USING: arrays kernel sequences sets ;

: comb ( x x -- x )
    over empty? [ nip 1array ] [
        dup pick first intersects?
        [ [ unclip ] dip union comb ]
        [ [ 1 cut ] dip comb append ] if
    ] if ;

: consolidate ( x -- x ) { } [ comb ] reduce ;
