begin
    % outputs line on a newline %
    procedure showLine ( string(80) value line ); write( line );

    string(80) line;
    integer lineCount;
    read( lineCount );
    for lineNumber := 1 until lineCount do begin
        read( line );
        showLine( line )
    end for_lineNumber
end.
