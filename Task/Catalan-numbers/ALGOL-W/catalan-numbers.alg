begin
    % print the catalan numbers up to C15 %
    integer Cprev;
    Cprev := 1; % C0 %
    write(     s_w := 0, i_w := 3, 0, ": ", i_w := 9, Cprev );
    for n := 1 until 15 do begin
        Cprev := round( ( ( ( 4 * n ) - 2 ) / ( n + 1 ) ) * Cprev );
        write( s_w := 0, i_w := 3, n, ": ", i_w := 9, Cprev );
    end for_n
end.
