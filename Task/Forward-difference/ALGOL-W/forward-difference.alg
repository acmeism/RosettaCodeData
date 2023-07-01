begin
    % calculate forward differences                                  %

    % sets elements of B to the first order forward differences of A %
    % A should have bounds 1 :: n, B should have bounds 1 :: n - 1   %
    procedure FirstOrderFDifference ( integer array A( * )
                                    ; integer array B( * )
                                    ; integer value n
                                    ) ;
        for i := 2 until n do B( i - 1 ) := A( i ) - A( i - 1 );

    integer array v   ( 1 :: 10 );
    integer array diff( 1 ::  9 );
    integer vPos, length;

    % construct the initial values array                              %
    vPos := 1;
    for i := 90, 47, 58, 29, 22, 32, 55, 5, 55, 73 do begin
        v( vPos ) := i;
        vPos := vPos + 1
    end for_i ;
    % calculate and show the differences                              %
    i_w    := 5; % set output format %
    length := 10;
    for order := 1 until length - 1 do begin
        FirstOrderFDifference( v, diff, length );
        length := length - 1;
        write( order, ": " ); for i := 1 until length do writeon( diff( i ) );
        for i := 1 until length do v( i ) := diff( i )
    end for_order
end.
