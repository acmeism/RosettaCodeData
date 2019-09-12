begin
    % returns true if n is perfect, false otherwise                %
    % n must be > 0                                                %
    logical procedure isPerfect ( integer value candidate ) ;
        begin
            integer sum;
            sum    := 1;
            for f1 := 2 until round( sqrt( candidate ) ) do begin
                if candidate rem f1 = 0 then begin
                    integer f2;
                    sum := sum + f1;
                    f2  := candidate div f1;
                    % avoid e.g. counting 2 twice as a factor of 4 %
                    if f2 > f1 then sum := sum + f2
                end if_candidate_rem_f1_eq_0 ;
            end for_f1 ;
            sum = candidate
        end isPerfect ;

    % test isPerfect                                               %
    for n := 2 until 10000 do if isPerfect( n ) then write( n );
end.
