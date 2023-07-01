begin
    % record structure that will be used to return the middle 3 digits of a number   %
    % if the middle three digits can't be determined, isOk will be false and message %
    % will contain an error message                                                  %
    % if the middle 3 digts can be determined, middle3 will contain the middle 3     %
    % digits and isOk will be true                                                   %
    record MiddleThreeDigits ( integer middle3; logical isOk; string(80) message );

    % finds the middle3 digits of a number or describes why they can't be found      %
    reference(MiddleThreeDigits) procedure findMiddleThreeDigits ( integer value number ) ;
        begin
            integer n, digitCount, d;

            n          := abs( number );
            % count the number of digits the number has %
            digitCount := if n = 0 then 1 else 0;
            d          := n;
            while d > 0 do begin
                digitCount := digitCount + 1;
                d          := d div 10
            end while_d_gt_0 ;
            if      digitCount < 3        then MiddleThreeDigits( 0, false, "Number must have at least 3 digits"       )
            else if not odd( digitCount ) then MiddleThreeDigits( 0, false, "Number must have an odd number of digits" )
            else begin
                % can find the middle three digits %
                integer m3;
                m3 := n;
                for d := 1 until ( digitCount - 3 ) div 2 do m3 := m3 div 10;
                MiddleThreeDigits( m3 rem 1000, true, "" )
            end
        end findMiddleThreeDigits ;

    % test the findMiddleThreeDigits procedure %
    for n := 123, 12345, 1234567, 987654321, 10001, -10001, -123, -100, 100, -12345, 1, 2, -1, -10, 2002, -2002, 0 do begin
        reference(MiddleThreeDigits) m3;
        i_w := 10; s_w := 0; % set output formating %
        m3 := findMiddleThreeDigits( n );
        write( n, ": " );
        if not isOk(m3) then writeon( message(m3) )
        else begin
            % as we return the middle three digits as an integer, we must manually 0 pad %
            if middle3(m3) < 100 then writeon( "0" );
            if middle3(m3) <  10 then writeon( "0" );
            writeon( i_w := 1, middle3(m3) )
        end
    end for_n

end.
