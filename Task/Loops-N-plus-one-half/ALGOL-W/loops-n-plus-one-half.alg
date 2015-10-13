begin
    integer i;
    i := 0;
    while
        begin
           i := i + 1;
           writeon( i );
           i < 10
        end
    do
    begin
       writeon( "," )
    end
end.
