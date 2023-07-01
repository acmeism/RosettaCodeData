begin
    % define mutually recursive funtions F and M that compute the elements   %
    % of the Hofstadter Female and Male sequences                            %

    integer procedure F ( integer value n ) ;
        if n = 0 then 1 else n - M( F( n - 1 ) );

    integer procedure M ( integer value n ) ;
        if n = 0 then 0 else n - F( M( n - 1 ) );

    % print the first few elements of the sequences                          %
    i_w := 2; s_w := 1; % set I/O formatting                                 %
    write( "F: " );
    for i := 0 until 20 do writeon( F( i ) );
    write( "M: " );
    for i := 0 until 20 do writeon( M( i ) );

end.
