begin
    integer dimension1UpperBound, dimension2UpperBound;
    write( "upper bound for dimension 1: " );
    read( dimension1UpperBound );
    write( "upper bound for dimension 2: " );
    read( dimension2UpperBound );

    begin
        % we start a new block because declarations must precede statements %
        % and variables in array bounds must be from outside the block      %
        integer array matrix ( 1 :: dimension1UpperBound
                             , 1 :: dimension2UpperBound
                             );
        % set the first element - the program will crash if the user input  %
        % upper bounds less than 1                                          %
        matrix( 1, 1 ) := 3;
        % write it                                                          %
        write( matrix( 1, 1 ) );
        % the array is automatically deleted when the block ends            %
    end

end.
