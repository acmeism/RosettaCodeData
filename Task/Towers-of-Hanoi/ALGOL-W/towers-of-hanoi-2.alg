begin % iterative towers of hanoi - translated from Tiny Basic %
    integer d, n;
    while begin writeon( "How many disks? " );
                read( d );
                d < 1 or d > 10
          end
    do begin end;
    n := 1;
    while d not = 0 do begin
        d := d - 1;
        n := 2 * n
    end;
    for x := 1 until n - 1 do begin
        integer s, t;
        % Algol W has the necessary bit and modulo operators so these are used here %
        %         instead of implementing them via subroutines                      %
        s :=   number( bitstring( x ) and bitstring( x - 1 ) )       rem 3;
        t := ( number( bitstring( x ) or  bitstring( x - 1 ) ) + 1 ) rem 3;
        write( i_w := 1, s_w := 0, "Move disc on peg ", s + 1, " to peg ", t + 1 )
    end
end.
