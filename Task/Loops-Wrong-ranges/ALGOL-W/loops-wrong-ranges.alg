begin
    % sets the first n elements of s to the sequences of values specified by start, stop and increment    %
    % s( 0 ) is set to the number of elements of s that have been set, in case the sequence ends before n %
    procedure sequence ( integer array s ( * )
                       ; integer value n, start, stop, increment
                       ) ;
    begin
        integer sPos;
        for j := 0 until n do s( j ) := 0;
        sPos  := 1;
        for j := start step increment until stop do begin
            if sPos > n then goto done;
               s( sPos ) := j;
               s( 0    ) := s( 0 ) + 1;
               sPos      := sPos + 1;
       end for_j ;
done:
    end sequence ;
    % tests the sequence procedure %
    procedure testSequence( integer    value start, stop, increment
                          ; string(48) value legend
                          ) ;
    begin
        integer array s ( 0 :: 10 );
        sequence( s, 10, start, stop, increment );
        s_w := 0; % set output formating %
        i_w := 4;
        write( legend, ": " );
        for i := 1 until s( 0 ) do writeon( s( i ) )
    end testSequence ;
    % task trest cases %
    testSequence( -2,  2,  1, "Normal"                                      );
    testSequence( -2,  2,  0, "Zero increment"                              );
    testSequence( -2,  2, -1, "Increments away from stop value"             );
    testSequence( -2,  2, 10, "First increment is beyond stop value"        );
    testSequence(  2, -2,  1, "Start more than stop: positive increment"    );
    testSequence(  2,  2,  1, "Start equal stop: positive increment"        );
    testSequence(  2,  2, -1, "Start equal stop: negative increment"        );
    testSequence(  2,  2,  0, "Start equal stop: zero increment"            );
    testSequence(  0,  0,  0, "Start equal stop equal zero: zero increment" )
end.
