begin % find elements of the inventory sequence                               %

    integer maxToShow                    % last value to show first element > %
          , maxNumber                        % max. element value to consider %
          ;
    maxToShow := 10000;
    maxNumber := maxToShow + 1000;

    begin
        integer array occurs( 0 :: maxNumber );    % times each number occurs %
        integer nextToShow, seqPos, element, n;

        for i := 0 until maxNumber do occurs( i ) := 0;
        seqPos          := 0;                   % current end of the sequence %
        nextToShow      := 1000;        % first value to show first element > %
        while nextToShow <= maxToShow do begin
            element     := 1;                    % any non-zero value will do %
            n           := -1;
            while nextToShow <= maxToShow and element not = 0 do begin
                n       := n + 1;
                element := occurs( n );
                seqPos  := seqPos + 1;
                if seqPos <= 100 then begin
                    writeon( i_w := 4, s_w := 0, " ", element );
                    if seqPos rem 10 = 0 then write()
                end else if element > nextToShow then begin
                    write( i_w := 8, s_w := 0
                         , "Element ", seqPos, " (", element, ") is first > ", i_w := 6, nextToShow
                         );
                    nextToShow := nextToShow + 1000
                end;
                if element < maxNumber then occurs( element ) := occurs( element ) + 1
            end
        end
    end

end.
