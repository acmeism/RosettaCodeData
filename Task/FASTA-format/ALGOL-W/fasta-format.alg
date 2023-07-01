begin
    % reads FASTA format data from standard input and write the results to standard output %
    % only handles the ">" line start                                                      %
    string(256) line;
    % allow the program to continue after reaching end-of-file %
    ENDFILE := EXCEPTION( false, 1, 0, false, "EOF" );
    % handle the input %
    readcard( line );
    while not XCPNOTED(ENDFILE) do begin
        % strings are fixed length in Algol W - we need to find the line lengh with trailing spaces removed %
        integer len;
        len := 255;
        while len > 0 and line( len // 1 ) = " " do len := len - 1;
        if len > 0 then begin % non-empty line %
            integer pos;
            pos := 0;
            if line( 0 // 1 ) = ">" then begin % header line %
                write();
                pos := 1;
            end if_header_line ;
            for cPos := pos until len do writeon( line( cPos // 1 ) );
            if line( 0 // 1 ) = ">" then writeon( ": " )
        end if_non_empty_line ;
        readcard( line );
    end while_not_eof
end.
