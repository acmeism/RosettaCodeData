begin
    % construct a magic square of odd order - as a procedure can't return an %
    % array, the caller must supply one that is big enough                   %
    logical procedure magicSquare( integer array square ( *, * )
                                 ; integer value order
                                 ) ;
        if not odd( order ) or order < 1 then begin
            % can't make a magic square of the specified order               %
            false
            end
        else begin
            % order is OK - construct the square using de la Loubère's       %
            % algorithm as in the wikipedia page                             %

            % ensure a row/col position is on the square                     %
            integer procedure inSquare( integer value pos ) ;
                if pos < 1 then order else if pos > order then 1 else pos;
            % move "up" a row in the square                                  %
            integer procedure up   ( integer value row ) ; inSquare( row - 1 );
            % move "accross right" in the square                             %
            integer procedure right( integer value col ) ; inSquare( col + 1 );

            integer  row, col;
            % initialise square                                              %
            for i := 1 until order do for j := 1 until order do square( i, j ) := 0;

            % initial position is the middle of the top row                  %
            col := ( order + 1 ) div 2;
            row := 1;
            % construct square                                               %
            for i := 1 until ( order * order ) do begin
                square( row, col ) := i;
                if square( up( row ), right( col ) ) not = 0 then begin
                    % the up/right position is already taken, move down      %
                    row := row + 1;
                    end
                else begin
                    % can move up/right                                      %
                    row := up(    row );
                    col := right( col );
                end
            end for_i;
            % sucessful result                                               %
            true
        end magicSquare ;

    % prints the magic square                                                %
    procedure printSquare( integer array  square ( *, * )
                         ; integer value  order
                         ) ;
    begin
        integer sum, w;

        % set integer width to accomodate the largest number in the square   %
        w := ( order * order ) div 10;
        i_w := s_w := 1;
        while w > 0 do begin i_w := i_w + 1; w := w div 10 end;

        for i := 1 until order do sum := sum + square( 1, i );
        write( "maqic square of order ", order, ": sum: ", sum );
        for i := 1 until order do begin
            write( square( i, 1 ) );
            for j := 2 until order do writeon( square( i, j ) )
        end for_i

    end printSquare ;

    % test the magic square generation                                       %

    integer array sq ( 1 :: 11, 1 :: 11 );

    for i := 1, 3, 5, 7 do begin
        if magicSquare( sq, i ) then printSquare( sq, i )
                                else write( "can't generate square" );
    end for_i

end.
