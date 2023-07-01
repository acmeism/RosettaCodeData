begin
    % Horner's rule for polynominal evaluation                             %
    % returns the value of the polynominal defined by coefficients,        %
    %         at the point x. The number of coefficients must be in ub     %
    %         the coefficients should be in order with x^0 first, x^n last %
    real procedure Horner( real    array coefficients ( * )
                         ; integer value ub
                         ; real    value x
                         ) ;
    begin
        real xValue;
        xValue := 0;
        for i := ub step -1 until 1 do xValue := ( xValue * x ) + coefficients( i );
        xValue
    end Horner ;
    % task test case                                                       %
    begin
        real array coefficients ( 1 :: 4 );
        integer    cPos;
        cPos := 1;
        for i := -19, 7, -4, 6 do begin
            coefficients( cPos ) := i;
            cPos                 := cPos + 1
        end for_i ;
        write( r_format := "A", r_w := 8, r_d := 2, Horner( coefficients, 4, 3 ) )
    end test_cases
end.
