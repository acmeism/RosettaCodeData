begin % compute values of the Mertens function                      %
    integer array M ( 1 :: 1000 );
    integer k, zero, cross;
    % Generate Mertens numbers                                      %
    M( 1 ) := 1;
    for n := 2 until 1000 do begin
        M( n ) := 1;
        for k := 2 until n do M( n ) := M( n ) - M( n div k )
    end for_n ;
    % Print table                                                   %
    write( "The first 99 Mertens numbers are:" );
    write( "   " );
    k := 9;
    for n := 1 until 99 do begin
        writeon( i_w := 3, s_w := 0, M( n ) );
        k := k - 1;
        if k = 0 then begin
            k := 10;
            write()
        end if_k_eq_0
    end for_n ;
    % Calculate zeroes and crossings                                %
    zero  := 0;
    cross := 0;
    for n :=2 until 1000 do begin
        if M( n ) = 0 then begin
            zero := zero + 1;
            if M( n - 1 ) not = 0 then cross := cross + 1
        end if_M_n_eq_0
    end for_n ;
    write( i_w := 2, s_w := 0, "M(N) is zero ", zero, " times." );
    write( i_w := 2, s_w := 0, "M(N) crosses zero ", cross, " times." )
end.
