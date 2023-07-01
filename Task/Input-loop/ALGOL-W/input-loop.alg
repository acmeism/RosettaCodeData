begin
    string(80) line;
    % allow the program to continue after reaching end-of-file %
    % without this, end-of-file would cause a run-time error   %
    ENDFILE := EXCEPTION( false, 1, 0, false, "EOF" );
    % read lines until end of file                             %
    read( line );
    while not XCPNOTED(ENDFILE) do begin
        write( line );
        read(  line )
    end
end.
