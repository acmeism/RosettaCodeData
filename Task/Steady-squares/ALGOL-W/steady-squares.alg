begin % find steady squares - numbers whose square ends in the number        %
      %      e.g.: 376^2 = 141 376                                           %

    % checks wheher n^2 mod p10 = n, i.e. n is a steady square and displays  %
    %        a message if it is                                              %
    procedure possibleSteadySuare ( integer value n, p10 ) ;
        if ( n * n ) rem p10 = n then write( i_w := 4, s_w := 0, n, "^2: ", i_w := 1, n * n );

    integer powerOfTen;
    powerOfTen := 10;

    % note the final digit must be 1, 5 or 6                                 %
    for p := 0 step 10 until 10000 do begin;
        if p = powerOfTen then begin
            % number of digits have increased                                %
            powerOfTen := powerOfTen * 10
        end if_p_eq_powerOfTen ;
        possibleSteadySuare( p + 1, powerOfTen );
        possibleSteadySuare( p + 5, powerOfTen );
        possibleSteadySuare( p + 6, powerOfTen )
    end
end.
