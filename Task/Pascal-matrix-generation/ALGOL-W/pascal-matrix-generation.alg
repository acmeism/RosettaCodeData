begin
    % initialises m to an upper Pascal matrix of size n %
    % the bounds of m must be at least 1 :: n, 1 :: n   %
    procedure upperPascalMatrix ( integer array m( *, * )
                                ; integer value n
                                ) ;
    begin
        for j := 1 until n do m( 1, j ) := 1;
        for i := 2 until n do begin
            m( i, 1 ) := 0;
            for j := 2 until n do m( i, j ) := m( i - 1, j - 1 ) + m( i, j - 1 )
        end for_i
    end upperPascalMatrix ;

    % initialises m to a lower Pascal matrix of size n  %
    % the bounds of m must be at least 1 :: n, 1 :: n   %
    procedure lowerPascalMatrix ( integer array m( *, * )
                               ; integer value n
                               ) ;
    begin
        for i := 1 until n do m( i, 1 ) := 1;
        for j := 2 until n do begin
            m( 1, j ) := 0;
            for i := 2 until n do m( i, j ) := m( i - 1, j - 1 ) + m( i - 1, j )
        end for_j
    end lowerPascalMatrix ;

    % initialises m to a symmetric Pascal matrix of size n %
    % the bounds of m must be at least 1 :: n, 1 :: n   %
    procedure symmetricPascalMatrix ( integer array m( *, * )
                                    ; integer value n
                                    ) ;
    begin
        for i := 1 until n do begin
            m( i, 1 ) := 1;
            m( 1, i ) := 1
        end for_i;
        for j := 2 until n do for i := 2 until n do m( i, j ) := m( i, j - 1 ) + m( i - 1, j )
    end symmetricPascalMatrix ;

    begin % test the pascal matrix procedures %

        % print the matrix m with the specified field width %
        % the bounds of m must be at least 1 :: n, 1 :: n   %
        procedure printMatrix ( integer array m( *, * )
                              ; integer value n
                              ; integer value fieldWidth
                              ) ;
        begin
            for i := 1 until n do begin
                write(                         i_w := fieldWidth, s_w := 0, " ", m( i, 1 ) );
                for j := 2 until n do writeon( i_w := fieldWidth, s_w := 0, " ", m( i, j ) )
            end for_i
        end printMatrix ;

        integer array m( 1 :: 10, 1 :: 10 );
        integer n, w;

        n := 5; w := 2;
        upperPascalMatrix(     m, n ); write( "upper:"     ); printMatrix( m, n, w );
        lowerPascalMatrix(     m, n ); write( "lower:"     ); printMatrix( m, n, w );
        symmetricPascalMatrix( m, n ); write( "symmetric:" ); printMatrix( m, n, w )

    end

end.
