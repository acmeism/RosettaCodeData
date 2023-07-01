begin
    % the Algol W standard procedure odd returns true if its integer  %
    % parameter is odd, false if it is even                           %
    for i := 1, 1702, 23, -26
    do begin
        write( i, " is ", if odd( i ) then "odd" else "even" )
    end for_i
end.
