begin % find the prime decompositionmtion of some integers                  %
    % increments n and returns the new value                                %
    integer procedure inc ( integer value result n ) ; begin n := n + 1; n end;
    % divides n by d and returns the result                                 %
    integer procedure over ( integer value result n
                           ; integer value d
                           ) ; begin n := n div d; n end;
    % sets the elements of f to the prime factors of n                      %
    %      the bounds of f should be 0 :: x where x is large enough to hold %
    %      all the factors, f( 0 ) will contain 6he number of factors       %
    procedure decompose ( integer value n; integer array f ( * ) ) ;
    begin
        integer d, v;
        f( 0 ) := 0;
        v      := abs n;
        if v > 0 and v rem 2 = 0 then begin
            f( inc( f( 0 ) ) ) := 2;
            while over( v, 2 ) > 0 and v rem 2 = 0 do f( inc( f( 0 ) ) ) := 2;
        end if_2_divides_v ;
        d := 3;
        while d * d <= v do begin
            if v rem d = 0 then begin
                f( inc( f( 0 ) ) ) := d;
                while over( v, d ) > 0 and v rem d = 0 do f( inc( f( 0 ) ) ) := d;
            end if_d_divides_v ;
            d := d + 2
        end while_d_squared_le_v ;
        if v > 1 then f( inc( f( 0 ) ) ) := v
    end factorise ;

    % some test cases                                                        %
    for n := 0, 1, 7, 31, 127, 2047, 8191, 131071, 524287, 2520, 32767, 8855, 441421750 do begin
       integer array f( 0 :: 20 );
       decompose( n, f );
       write( s_w := 0, n, ": " );
       for fPos := 1 until f( 0 ) do writeon( i_w := 1, s_w := 0, " ", f( fPos ) );
    end for_n ;
end.
