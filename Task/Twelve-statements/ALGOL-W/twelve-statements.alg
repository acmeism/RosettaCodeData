begin
    % we have 12 statements to determine the truth/falsehood of (see task)  %

    logical array stmt, expected( 1 :: 12 );

    % logical (boolean) to integer utility procedure                        %
    integer procedure toInteger ( logical value v ) ; if v then 1 else 0;

    % procedure to determine whether the statements are true or not         %
    procedure findExpectedValues ;
    begin
        expected(  1 ) := true;
        expected(  2 ) := 3 = ( toInteger( stmt(  7 ) ) + toInteger( stmt(  8 ) )
                              + toInteger( stmt(  9 ) ) + toInteger( stmt( 10 ) )
                              + toInteger( stmt( 11 ) ) + toInteger( stmt( 12 ) )
                              );
        expected(  3 ) := 2 = ( toInteger( stmt(  2 ) ) + toInteger( stmt(  4 ) )
                              + toInteger( stmt(  6 ) ) + toInteger( stmt(  8 ) )
                              + toInteger( stmt( 10 ) ) + toInteger( stmt( 12 ) )
                              );
        expected(  4 ) := ( not stmt( 5 ) ) or ( stmt( 6 ) and stmt( 7 ) );
        expected(  5 ) := not ( stmt( 2 ) or stmt( 3 ) or stmt( 4 ) );
        expected(  6 ) := 4 = ( toInteger( stmt(  1 ) ) + toInteger( stmt(  3 ) )
                              + toInteger( stmt(  5 ) ) + toInteger( stmt(  7 ) )
                              + toInteger( stmt(  9 ) ) + toInteger( stmt( 11 ) )
                              );
        expected(  7 ) := stmt( 2 ) not = stmt( 3 );
        expected(  8 ) := ( not stmt( 7 ) ) or ( stmt( 5 ) and stmt( 6 ) );
        expected(  9 ) := 3 = ( toInteger( stmt(  1 ) ) + toInteger( stmt(  2 ) )
                              + toInteger( stmt(  3 ) ) + toInteger( stmt(  4 ) )
                              + toInteger( stmt(  5 ) ) + toInteger( stmt(  6 ) )
                              );
        expected( 10 ) := stmt( 11 ) and stmt( 12 );
        expected( 11 ) := 1 = ( toInteger( stmt(  7 ) )
                              + toInteger( stmt(  8 ) )
                              + toInteger( stmt(  9 ) )
                              );
        expected( 12 ) := 4 = ( toInteger( stmt(  1 ) ) + toInteger( stmt(  2 ) )
                              + toInteger( stmt(  3 ) ) + toInteger( stmt(  4 ) )
                              + toInteger( stmt(  5 ) ) + toInteger( stmt(  6 ) )
                              + toInteger( stmt(  7 ) ) + toInteger( stmt(  8 ) )
                              + toInteger( stmt(  9 ) ) + toInteger( stmt( 10 ) )
                              + toInteger( stmt( 11 ) )
                              );
    end expected ;

    % clearly, statement 1 is true, however to enumerate the near           %
    % solutions, we need to consider "solutions" where statement 1 is false %
    % we iterate through the possibilities for the statements,              %
    % looking for a non-contradictory set of values                         %
    % we print the solutions with allowedContradictions contradictions      %
    procedure printSolutions ( integer    value allowedContradictions
                             ; string(60) value heading
                             ) ;
    begin
        logical array wrong( 1 :: 12 );
        write( heading );
        write( "     1  2  3  4  5  6  7  8  9 10 11 12"  );
        write( "    ====================================" );
        % there are 12 statements, so we have 2^12 possible combinations    %
        for solution := 1 until 4096 do begin
            integer n, incorrect;
            % convert the number to the set of true/false values            %
            n := solution;
            for dPos := 1 until 12 do begin
                stmt( dPos ) := odd( n );
                n := n div 2;
            end for_dPos ;
            % get the expected values of the statements, based on the       %
            % suggested values                                              %
            findExpectedValues;
            % count the contradictions, if we have the required number,     %
            % print the solution                                            %
            incorrect := 0;
            for dPos := 1 until 12 do begin
                wrong( dPos ) := expected( dPos ) not = stmt( dPos );
                incorrect     := incorrect + toInteger( wrong( dPos ) );
            end for_dPos ;
            if incorrect = allowedContradictions then begin
                % have a solution                                            %
                write( "    " );
                for s := 1 until 12 do writeon( s_w := 0
                                              , " "
                                              , if stmt(  s ) then "T" else "-"
                                              , if wrong( s ) then "*" else " "
                                              );
            end ;
        end for_solution ;
    end printSolutions ;

    % find complete solutions                                                %
    printSolutions( 0, "Solutions" );
    % find near solutions                                                    %
    printSolutions( 1, "Near solutions (incorrect values marked ""*"")" );

end.
