begin
    % print the integers from 1 onwards                                       %
    % Algol W only has 32-bit integers. When i reaches 2^32,                  %
    % an integer overflow event would be raised which by default,             %
    % should terminate the program                                            %
    integer i;
    i := 1;
    while true do begin
        write( i );
        i := i + 1
    end loop_forever ;
end.
