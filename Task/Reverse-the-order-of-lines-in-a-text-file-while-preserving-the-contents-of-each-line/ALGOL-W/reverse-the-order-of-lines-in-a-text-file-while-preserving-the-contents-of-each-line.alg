begin % reverse the order of the lines read from standard input %
    % record to hold a line and link to the next %
    record LinkedLine ( string(256) text; reference(LinkedLine) next );
    string(256) line;
    reference(LinkedLine) lines;
    % allow the program to continue after reaching end-of-file %
    ENDFILE := EXCEPTION( false, 1, 0, false, "EOF" );
    % handle the input %
    lines := null;
    readcard( line );
    while not XCPNOTED(ENDFILE) do begin
        lines := LinkedLine( line, lines );
        readcard( line )
    end while_not_eof ;
    % show the lines in reverse order %
    while lines not = null do begin
        integer len;
        % find the length of the line with trailing spaces removed %
        len := 255;
        line := text(lines);
        while len > 0 and line( len // 1 ) = " " do len := len - 1;
        % print the line, note Algol W does not allow variable length substrings %
        write( s_w := 0, line( 0 // 1 ) );
        for cPos := 1 until len do writeon( s_w := 0, line( cPos // 1 ) );
        lines := next(lines)
    end while_lines_ne_null
end.
