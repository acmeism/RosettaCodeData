begin
    % sets the elements of out to the elements of in that return true from applying the where procedure to them %
    %      the bounds of in must be 1 :: inUb - out must be at least as big as in and the number of matching    %
    %      elements is returned in outUb - in and out can be the same array                                     %
    procedure select ( integer array in  ( * ); integer value  inUb
                     ; integer array out ( * ); integer result outUb
                     ; logical procedure where % ( integer value n ) %
                     ) ;
    begin
        outUb := 0;
        for i := 1 until inUb do begin
            if where( in( i ) ) then begin
                outUb := outUb + 1;
                out( outUb ) := in( i )
            end f_where_in_i
        end for_i
    end select ;
    % test the select procedure %
    logical procedure isEven ( integer value n ) ; not odd( n );
    integer array t, out ( 1 :: 10 );
    integer outUb;
    for i := 1 until 10 do t( i ) := i;
    select( t, 10, out, outUb, isEven );
    for i := 1 until outUb do writeon( i_w := 3, s_w := 0, out( i ) );
    write()
end.
