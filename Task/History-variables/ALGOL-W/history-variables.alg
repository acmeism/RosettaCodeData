begin
    % implements integer history variables                                 %
    % similar history types could be defined for other types of variable   %
    record HInteger ( integer iValue; reference(HInteger) iPrev );
    % sets the latest value of hv to n                                     %
    procedure setIhv ( reference(HInteger) value result hv; integer value n ) ; hv := HInteger( n, hv );
    % declare an integer history variable                                  %
    reference(HInteger) hv;
    % initialise the history to a null value                               %
    hv := null;
    % assign three values                                                  %
    setIhv( hv, 1 );
    setIhv( hv, 2 );
    setIhv( hv, 3 );
    % show the history of hv                                               %
    begin
        reference(HInteger) h;
        write( "hv history: " );
        h := hv;
        while h not = null do begin
            writeon( i_w := 3, s_w := 0, iValue(h), " " );
            h := iPrev(h)
        end while_h_ne_null
    end;
    % remove the values from hv, summing them as in the Ada sample         %
    begin
        integer s;
        s := 0;
        while hv not = null do begin
            s  := s + iValue(hv);
            hv := iPrev(hv)
        end while_hv_ne_null ;
        write( "Sum of the historic values: ", s )
    end
end.
