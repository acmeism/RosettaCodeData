begin
    record    T  ( integer n, m );
    reference(T) singleT;
    integer      numberOfElements;
    singleT          := T( 0, 0 );
    numberOfElements := 3;
    begin
        reference(T) array tArray ( 1 :: numberOfElements );
        % initialise the "right" way            %
        for i := 1 until numberOfElements do begin
            tArray( i )    := T( i, i * 2 );
            m(tArray( i )) := m(tArray( i )) + 1;
        end for_i ;
        write();
        for i := 1 until numberOfElements do writeon( i_w := 1, s_w := 0, n(tArray( i )), ", ", m(tArray( i )), "; " );
        % initialise the "wrong" way            %
        for i := 1 until numberOfElements do begin
            tArray( i )    := singleT;
            m(tArray( i )) := m(tArray( i )) + 1;
        end for_i ;
        write();
        for i := 1 until numberOfElements do writeon( i_w := 1, s_w := 0, n(tArray( i )), ", ", m(tArray( i )), "; " )
    end
end.
