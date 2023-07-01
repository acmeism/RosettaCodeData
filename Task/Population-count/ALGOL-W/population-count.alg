begin
    % returns the population count (number of bits on) of the non-negative integer n %
    integer procedure populationCount( integer value n ) ;
            begin
                integer v, count;
                v     := n;
                count := 0;
                while v > 0 do begin
                    if odd( v ) then count := count + 1;
                    v     := v div 2
                end while_v_gt_0 ;
                count
            end populationCount ;
    % returns the sum of population counts of the elements of the array n            %
    %         the bounds of n must be 1 :: length                                    %
    integer procedure arrayPopulationCount( integer array n ( * ); integer value length ) ;
            begin
                integer count;
                count := 0;
                for i := 1 until length do count := count + populationCount( n( i ) );
                count
            end arrayPopulationCount ;
    begin %task requirements %
        integer array power( 1 :: 8 );
        integer n, count, carry;
        % population counts of the first 30 powers of three %
        % Algol W integers are 32-bit, so we simulate 64-bit with an array of integers %
        % the only operation we need is multiplication by 3                            %
        % we use 8 bits of each number                                                 %
        % start with 3^0, which is 1 %
        for i := 1 until 8 do power( i ) := 0;
        power( 1 ) := 1;
        write( i_w := 1, s_w := 0, "3^x  population: ", arrayPopulationCount( power, 8 ) );
        for p := 1 until 29 do begin
            carry := 0;
            for b := 1 until 8 do begin
                integer bValue;
                bValue     := ( power( b ) * 3 ) + carry;
                carry      := bValue div 256;
                power( b ) := bValue rem 256
            end for_b ;
            writeon( i_w := 1, s_w := 0, " ", arrayPopulationCount( power, 8 ) )
        end for_p ;

        % evil numbers (even population count) %
        write( "evil    numbers:" );
        n     := 0;
        count := 0;
        while count < 30 do begin
            if not odd( populationCount( n ) ) then begin
                writeon( i_w := 1, s_w := 0, " ", n );
                count := count + 1
            end if_not_odd_populationCount ;
            n := n + 1
        end evil_numbers_loop ;

        % odious numbers (odd population count %
        write( "odious  numbers:" );
        n     := 0;
        count := 0;
        while count < 30 do begin
            if odd( populationCount( n ) ) then begin
                writeon( i_w := 1, s_w := 0, " ", n );
                count := count + 1
            end if_odd_populationCount ;
            n := n + 1
        end odious_numbers_loop
   end
end.
