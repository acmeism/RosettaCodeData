begin
    % procedure to sum the elements of a vector. As the procedure can't find %
    % the bounds of the array for itself, we pass them in lb and ub          %
    real procedure sumSquares ( real    array vector ( * )
                              ; integer value lb
                              ; integer value ub
                              ) ;
    begin
        real sum;
        sum := 0;
        for i := lb until ub do sum := sum + ( vector( i ) * vector( i ) );
        sum
    end sumOfSquares ;

    % test the sumSquares procedure                                          %
    real array numbers ( 1 :: 5 );
    for i := 1 until 5 do numbers( i ) := i;
    r_format := "A"; r_w := 10; r_d := 1; % set fixed point output           %
    write( sumSquares( numbers, 1, 5 ) );
end.
