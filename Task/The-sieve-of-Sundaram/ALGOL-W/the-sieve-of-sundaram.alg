begin % sieve of Sundaram %
    integer n;
    string(1) none, mark1, mark2;
    n := 8000000; none := " "; mark1 := "1"; mark2 := "2";
    begin
        string(1) array mark  ( 1 ::   n );
        integer array list100 ( 1 :: 100 ); % First 100 primes. %
        integer last, mStep, count;
        last  := 0; % Millionth prime.          %
        mStep := 5; % Current step for marking. %
        count := 0; % Count of primes.          %
        for i := 1        until n do mark( i ) := none;
        for i := 4 step 3 until n do mark( i ) := mark1;

        for i := 1 until n do begin
            if mark( i ) = none then begin % Add/count a new odd prime.  %
                count := count + 1;
                if      count <=     100 then list100( count ) := 2 * i + 1
                else if count  = 1000000 then begin
                    last := 2 * i + 1;
                    goto foundLast
                end
                end
            else if mark( i ) = mark1 then begin % Mark new numbers using current step. %
                if i > 4 then begin
                    for k := i + mStep step mStep until n do begin
                        if mark( k ) = none then mark( k ) := mark2
                    end for_k;
                    mStep := mStep + 2
                end if_i_gt_4
            end
        end for_i;
foundLast:

        write( "First 100 Sundaram primes:" );
        for i := 1 until 100 do begin
            if i rem 10 = 1
            then write(   i_w := 3, s_w := 0,      list100( i ) )
            else writeon( i_w := 3, s_w := 0, " ", list100( i ) )
        end for_i ;
        write();
        if last = 0
        then write( i_w := 1, s_w := 0, "Not enough values in sieve. Found only ", count )
        else write( i_w := 1, s_w := 0, "The millionth Sundaram prime is ", last )
    end
end.
