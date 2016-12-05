begin
    % return the factors of n ( n should be >= 1 ) in the array factor       %
    % the bounds of factor should be 0 :: len (len must be at least 1)       %
    % the number of factors will be returned in factor( 0 )                  %
    procedure getFactorsOf ( integer value n
                           ; integer array factor( * )
                           ; integer value len
                           ) ;
    begin
        for i := 0 until len do factor( i ) := 0;
        if n >= 1 and len >= 1 then begin
            integer pos, lastFactor;
            factor( 0 ) := factor( 1 ) := pos := 1;
            % find the factors up to sqrt( n )                               %
            for f := 2 until truncate( sqrt( n ) ) + 1 do begin
                if ( n rem f ) = 0 and pos <= len then begin
                    % found another factor and there's room to store it      %
                    pos           := pos + 1;
                    factor( 0   ) := pos;
                    factor( pos ) := f
                end if_found_factor
            end for_f;
            % find the factors above sqrt( n )                               %
            lastFactor := factor( factor( 0 ) );
            for f := factor( 0 ) step -1 until 1 do begin
                integer newFactor;
                newFactor := n div factor( f );
                if newFactor > lastFactor and pos <= len then begin
                    % found another factor and there's room to store it      %
                    pos           := pos + 1;
                    factor( 0   ) := pos;
                    factor( pos ) := newFactor
                end if_found_factor
            end for_f;
        end if_params_ok
    end getFactorsOf ;


    % prpocedure to test getFactorsOf                                        %
    procedure testFactorsOf( integer value n ) ;
    begin
        integer array factor( 0 :: 100 );
        getFactorsOf( n, factor, 100 );
        i_w := 1; s_w := 0; % set output format                              %
        write( n, " has ", factor( 0 ), " factors:" );
        for f := 1 until factor( 0 ) do writeon( " ", factor( f ) )
    end testFactorsOf ;

    % test the factorising                                                   %
    for i := 1 until 100 do testFactorsOf( i )

end.
