begin % find elements of the Van Eck Sequence - first term is 0, following  %
      % terms are 0 if the previous was the first appearance of the element %
      %        or how far back in the sequence the last element appeared    %
    % sets s to the first n elements of the Van Eck sequence                %
    procedure VanEck ( integer array s ( * ) ; integer value n ) ;
    begin
        integer array pos ( 0 :: n );
        for i := 1 until n do s(   i ) := 0;
        for i := 0 until n do pos( i ) := 0;
        for i := 2 until n do begin
            integer j, prev;
            j    := i - 1;
            prev := s( j );
            if pos( prev ) not = 0 then begin
                    % not a new element                                     %
                    s( i ) := j - pos( prev )
            end if_pos_prev_ne_0 ;
            pos( prev ) := j
        end for_j;
    end VanEck ;
    % construct the first 1000 terms of the sequence                        %
    integer MAX_VAN_ECK;
    MAX_VAN_ECK := 1000;
    begin
        integer array seq ( 1 :: MAX_VAN_ECK );
        VanEck( seq, MAX_VAN_ECK );
        % show the first and last 10 elements                               %
        for i := 1 until 10 do writeon( i_w := 1, s_w := 0, " ", seq( i ) );
        write();
        for i := MAX_VAN_ECK - 9 until MAX_VAN_ECK do writeon( i_w := 1, s_w := 0, " ", seq( i ) );
        write()
    end
end.
