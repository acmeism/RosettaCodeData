begin % show some valuies of the Padovan n-step number sequences  %
    % sets R(i,j) to the jth element of the ith padovan sequence  %
    % maxS is the number of sequences to generate and maxE is the %
    % maximum number of elements for each sequence                %
    % maxS must be >= 2                                           %
    procedure PadovanSequences ( integer array R ( *, * )
                               ; integer value maxS, maxE
                               ) ;
    begin
        integer procedure min( integer value a, b ) ; if a < b then a else b;
        % sequence 2                                              %
        for x := 1 until min( maxE, 3 ) do R( 2, x ) := 1;
        for x := 4 until maxE do R( 2, x ) := R( 2, x - 2 ) + R( 2, x - 3 );
        % sequences 3 and above                                   %
        for N := 3 until maxS do begin
            for x := 1 until min( maxE, N + 1 ) do R( N, x ) := R( N - 1, x );
            for x := N + 2 until maxE do begin
                R( N, x ) := 0;
                for p := x - N - 1 until x - 2 do R( N, x ) := R( N, x ) + R( N, p )
            end for_x
        end for_N
    end PadovanSequences ;
    integer MAX_SEQUENCES, MAX_ELEMENTS;
    MAX_SEQUENCES :=  8;
    MAX_ELEMENTS  := 15;
    begin % calculate and show the sequences                      %
        % array to hold the Padovan Sequences                     %
        integer array R ( 2 :: MAX_SEQUENCES, 1 :: MAX_ELEMENTS );
        % construct the sequences                                 %
        PadovanSequences( R, MAX_SEQUENCES, MAX_ELEMENTS );
        % show the sequences                                      %
        write( "Padovan n-step sequences:" );
        for n := 2 until MAX_SEQUENCES do begin
            write( i_w := 1, s_w := 0, n, " |" );
            for x := 1 until MAX_ELEMENTS do writeon( i_w := 3, s_w := 0, " ", R( n, x ) )
        end for_n
    end
end.
