begin
    integer i;
    i := 0;
    while
        begin
            i := i + 1;
            write( i );
            ( i rem 6 ) not = 0
        end
    do begin end
end.
