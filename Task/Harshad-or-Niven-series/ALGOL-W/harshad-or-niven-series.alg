begin % find members of the Harshad/Niven series - numbers divisible by the sum of their digits %
    % returns the next member of the series above n                                             %
    integer procedure nextHarshad ( integer value n ) ;
    begin
        integer h, s;
        h := n;
        while begin
                  integer v;
                  v := h := h + 1;
                  s := 0;
                  while v > 0 do begin
                      s := s + v rem 10;
                      v :=     v div 10
                  end while_v_gt_0 ;
                  h rem s not = 0
        end do begin end;
        h
    end nextHarshad ;
    integer h;
    % show the first 20 members of the seuence %
    write( "First 20 Harshad/Niven numbers:" );
    h := 0;
    for i := 1 until 20 do begin
        h := nextHarshad( h );
        writeon( i_w := 1, s_w := 0, " ", h )
    end for_i ;
    write( i_w := 1, s_w := 0, "First Harshad/Niven number > 1000: ", nextHarshad( 1000 ) );
end.
