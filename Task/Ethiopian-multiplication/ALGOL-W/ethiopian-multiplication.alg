begin
    % returns half of a %
    integer procedure halve  ( integer value a ) ; a div 2;
    % returns a doubled %
    integer procedure double ( integer value a ) ; a * 2;
    % returns true if a is even, false otherwise %
    logical procedure even   ( integer value a ) ; not odd( a );
    % returns the product of a and b using ethopian multiplication %
    % rather than keep a table of the intermediate results,        %
    % we examine then as they are generated                        %
    integer procedure ethopianMultiplication ( integer value a, b ) ;
    begin
        integer v, r, accumulator;
        v           := a;
        r           := b;
        accumulator := 0;
        i_w := 4; s_w := 0; % set output formatting %
        while begin
            write( v );
            if even( v ) then writeon( "    ---" )
            else begin
                accumulator := accumulator + r;
                writeon( "   ", r );
            end;
            v := halve( v );
            r := double( r );
            v > 0
        end do begin end;
        write( "      =====" );
        accumulator
    end ethopianMultiplication ;
    % task test case %
    begin
        integer m;
        m := ethopianMultiplication( 17, 34 );
        write( "       ", m )
    end
end.
