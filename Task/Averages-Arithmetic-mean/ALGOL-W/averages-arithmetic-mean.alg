begin
    % procedure to find the mean of the elements of a vector.                %
    % As the procedure can't find the bounds of the array for itself,        %
    % we pass them in lb and ub          %
    real procedure mean ( real    array vector ( * )
                        ; integer value lb
                        ; integer value ub
                        ) ;
    begin
        real sum;
        assert( ub > lb ); % terminate the program if there are no elements  %
        sum := 0;
        for i := lb until ub do sum := sum + vector( i );
        sum / ( ( ub + 1 ) - lb )
    end mean ;

    % test the mean procedure by finding the mean of 1.1, 2.2, 3.3, 4.4, 5.5 %
    real array numbers ( 1 :: 5 );
    for i := 1 until 5 do numbers( i ) := i + ( i / 10 );
    r_format := "A"; r_w := 10; r_d := 2; % set fixed point output           %
    write( mean( numbers, 1, 5 ) );
end.
