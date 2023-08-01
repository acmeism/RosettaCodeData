begin % find amicable pairs p1, p2 where each is equal to the other's      %
      % proper divisor sum                                                 %

    integer MAX_NUMBER;
    MAX_NUMBER := 20000;

    begin
        integer array pdSum( 1 :: MAX_NUMBER ); % table of proper divisors %
        for i := 1 until MAX_NUMBER do pdSum( i ) := 1;
        for i := 2 until MAX_NUMBER do begin
            for j := i + i step i until MAX_NUMBER do pdSum( j ) := pdSum( j ) + i
        end for_i ;

        % find the amicable pairs up to 20 000                             %
        for p1 := 1 until MAX_NUMBER - 1 do begin
            integer pdSumP1;
            pdSumP1 := pdSum( p1 );
            if pdSumP1 > p1 and pdSumP1 <= MAX_NUMBER and pdSum( pdSumP1 ) = p1 then begin
                write( i_w := 5, s_w := 0, p1, " and ", pdSumP1, " are an amicable pair" )
            end if_pdSumP1_gt_p1_and_le_MAX_NUMBER
        end for_p1
    end
end.
