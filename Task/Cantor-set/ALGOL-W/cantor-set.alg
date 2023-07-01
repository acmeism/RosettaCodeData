begin
    % draw a Cantor Set using ASCII                                            %
    integer LINES;        % number of lines for the set                        %
    integer setWidth;     % width of each line of the set                      %
    % we must choose the line width so that the width of each segment is       %
    % divisible by 3 ( except for the final line where the segment width will  %
    % be 1 )                                                                   %
    LINES    := 5;
    setWidth := round( 3 ** ( LINES - 1 ) );
    begin % start new block so the array can have computed bounds              %
        logical array set ( 1 :: setWidth );
        integer segmentWidth;
        % start with a complete line %
        for i := 1 until setWidth do set( i ) := true;
        segmentWidth := setWidth;
        for l := 1 until LINES do begin
            % print the latest line, all lines start with a "#"                %
            write( "#" );
            for i := 2 until setWidth do writeon( if set( i ) then "#" else " " );
            % modify the line, replacing the middle third of each segment      %
            % with blanks, unless this was the last line                       %
            if l < LINES then begin
                integer   setPos;
                segmentWidth := segmentWidth div 3;
                setPos := 1;
                while setPos < ( setWidth - segmentWidth ) do begin
                    setPos := setPos + segmentWidth;
                    for charPos := setPos until ( setPos + segmentWidth ) - 1 do set( charPos ) := false;
                    setPos := setPos + segmentWidth
                end while_setPos_in_range ;
            end if_l_lt_LINES
        end for_l
    end
end.
