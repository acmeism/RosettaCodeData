begin % gnome sort %

    % gnome sorts in-place a, a must have bounds 1 :: size %
    procedure gnomeSort( integer array a ( * ); integer value size ) ;
    begin
        integer i, j;
        i := 2;
        j := 3;
        while i <= size do begin
            if a( i - 1 ) <= a( i ) then begin
                i := j;
                j := j + 1
                end
            else begin
                integer swap;
                swap       := a( i - 1 );
                a( i - 1 ) := a( i     );
                a( i     ) := swap;
                i          := i - 1;
                if i = 1 then begin
                    i := j;
                    j := j + 1
                end if_i_eq_1
            end if_a_i_minus_1_le_a_i__
        end while_i_lt_size
    end gnomeSort ;

    begin % test gnomeSort %
        integer array numbers ( 1 :: 11 );
        integer nPos;
        % constructy an array of integers and sort it %
        nPos := 1;
        for v := 4, 65, 2, 31, 0, 99, 2, 8, 3, 782, 1 do begin
            numbers( nPos ) := v;
            nPos            := nPos + 1
        end for_v ;
        gnomeSort( numbers, 11 );
        % print the sorted array %
        for n := 1 until 11 do writeon( i_w := 1, s_w := 0, " ", numbers( n ) )
    end tests
end.
