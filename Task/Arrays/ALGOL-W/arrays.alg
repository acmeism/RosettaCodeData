begin
    % declare an array %
    integer array a ( 1 :: 10 );
    % set the values %
    for i := 1 until 10 do a( i ) := i;
    % change the 3rd element %
    a( 3 ) := 27;
    % display the 4th element %
    write( a( 4 ) ); % would show 4 %
    % arrays with sizes not known at compile-time must be created in inner-blocks or procedures %
    begin
        integer array b ( a( 3 ) - 2 :: a( 3 ) ); % b has bounds 25 :: 27 %
        for i := a( 3 ) - 2 until a( 3 ) do b( i ) := i
    end
    % arrays cannot be part of records and cannot be returned by procecures though they can be passed %
    % as parameters to procedures                                                                     %
    % multi-dimension arrays are supported                                                            %
end.
