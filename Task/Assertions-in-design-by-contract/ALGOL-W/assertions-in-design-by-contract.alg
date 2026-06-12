begin
    long real procedure averageOfAbsolutes( integer array values( * )
                                          ; integer value valuesLength
                                          ) ;
    begin
        long real av;
        % Pre-condition. %
        assert( valuesLength > 0 );
        for i := 1 until valuesLength do av := av + abs( values( i ) );
        av := av / valuesLength;
        % Post-condition. %
        assert( av >= 0 );
        av
    end averageOfAbsolutes ;
    begin
        integer array v( 1 :: 2 );
        v( 1 ) := 1; v( 2 ) := 3;
        r_format := "A"; r_w := 6; r_d := 2; % set output formatting %
        write( averageOfAbsolutes( v, 2 ) )
    end
end.
