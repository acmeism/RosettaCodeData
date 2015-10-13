begin
    procedure move ( integer value n, from, to, via ) ;
        if n > 0 then begin
            move( n - 1, from, via, to );
            write( i_w := 1, s_w := 0, "Move disk from peg: ", from, " to peg: ", to );
            move( n - 1, via, to, from )
        end move ;

    move( 4, 1, 2, 3 )
end.
