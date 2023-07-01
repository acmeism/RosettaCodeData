begin
    % nth root algorithm                                              %
    % returns the nth root of A, A must be > 0                        %
    %         the required precision should be specified in precision %
    long real procedure nthRoot( long real value A
                               ; integer   value n
                               ; long real value precision
                               ) ;
        begin
            long real xk, xd;
            integer   n1;
            n1 := n - 1;
            xk := A / n;
            while begin
                xd := ( ( A / ( xk ** n1 ) ) - xk ) / n;
                xk := xk + xd;
                abs( xd ) > precision
            end do begin end;
            xk
        end nthRoot ;
    % test cases %
    r_format := "A"; r_w := 15; r_d := 6; % set output format %
    write( nthRoot( 7131.5 ** 10, 10, 1'-5 ) );
    write( nthRoot(           64,  6, 1'-5 ) );
end.
