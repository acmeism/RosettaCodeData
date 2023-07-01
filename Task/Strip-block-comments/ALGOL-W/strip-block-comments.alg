begin
    % strips block comments from a source                                     %
    % the source is read from standard input and the result written to        %
    % standard output, The comment start text is in cStart and the ending     %
    % is in cEnd.                                                             %
    % As strings are fixed length in Algol W, the first space in cStart/cEnd  %
    % is assumed to terminate the delimiter, i.e. the comment start/end       %
    % delimiters cannot contain spaces.                                       %
    % If non-blank, quote1 and quote2 are the string quote characters.        %
    % If escape is non-blank it indicates that quotes can be embedded in      %
    % string literals by preceding them with escape (as in C, java, etc.).    %
    procedure stripBlockComments( string(32) value cStart, cEnd
                                ; string(1)  value quote1, quote2, escape
                                ) ;
    begin
        integer     columnNumber, lineWidth;
        string(256) line;
        string(1)   currChar;
        string(1)   newlineChar;
        % gets the next source character                                      %
        procedure nextChar ;
        begin
            if      columnNumber = lineWidth then begin
                currChar     := newlineChar;
                columnNumber := columnNumber + 1
                end
            else if columnNumber > lineWidth then begin
                readcard( line );
                lineWidth := 256;
                while lineWidth > 0 and line( lineWidth - 1 // 1 ) = " " do lineWidth := lineWidth - 1;
                columnNumber := 1;
                currChar     := line( 0 // 1 )
                end
            else begin
                currChar     := line( columnNumber // 1 );
                columnNumber := columnNumber + 1
            end
        end nextChar ;
        % copy the current character and get the next                         %
        procedure copyAndNext ;
        begin
            if currChar = newlineChar then write()
                                      else writeon( currChar );
            nextChar
        end copyAndNext ;
        % skips the current character and gets the next                       %
        procedure skipAndNext ;
        begin
            if currChar not = newlineChar then currChar := " ";
            copyAndNext
        end skipAndNext ;
        % handle a string literal                                             %
        procedure stringLiteral( string(1) value quote, escape ) ;
        begin
            copyAndNext;
            while currChar not = quote and not XCPNOTED(ENDFILE) do begin
                if escape <> " " and currChar = escape then copyAndNext;
                if not XCPNOTED(ENDFILE) then copyAndNext
            end while_have_more_string ;
            if currChar = quote then copyAndNext
        end stringLiteral ;
        % returns true if the line continues with the specified text          %
        %         false if not.                                               %
        logical procedure remainingLineStartsWith ( string(32) value text ) ;
        begin
            logical   haveText;
            integer   lPos, wPos;
            haveText := currChar = text( 0 // 1 );
            lPos     := columnNumber;
            wPos     := 1;
            while haveText and wPos <= 32 and text( wPos // 1 ) not = " " do begin
                if lPos >= lineWidth then begin
                    % past the end of the line                                %
                    haveText := false
                    end
                else begin
                    % still have text on the line                             %
                    haveText := line( lPos // 1 ) = text( wPos // 1 );
                    wPos     := wPos + 1;
                    lPos     := lPos + 1;
                end if_past_end_of_line_
            end while_have_text_and_more_text ;
            haveText
        end remainingLineStartsWith ;
        % skips the number of leading non-blank characters in the delimiter   %
        procedure skipDelimiter( string(32) value delimiter ) ;
        begin
            integer dPos;
            dPos := 0;
            while dPos < 32 and not XCPNOTED(ENDFILE) and delimiter( dPos // 1 ) not = " " do begin
               dPos := dPos + 1;
               skipAndNext
           end while_not_at_end_of_delimiter
        end skipDelimiter ;
        newlineChar  := code( 10 );
        lineWidth    := 0;
        columnNumber := lineWidth + 1;
        currChar     := " ";
        % allow the program to continue after reaching end-of-file %
        ENDFILE      := EXCEPTION( false, 1, 0, false, "EOF" );
        % get the first source character                                      %
        nextChar;
        % strip the comments                                                  %
        while not XCPNOTED(ENDFILE) do begin
            if      currChar = " "    then copyAndNext
            else if remainingLineStartsWith( cStart ) then begin
                % have a comment                                              %
                skipDelimiter( cStart );
                while not remainingLineStartsWith( cEnd ) and not XCPNOTED(ENDFILE) do skipAndNext;
                skipDelimiter( cEnd )
                end
            else if currChar = quote1 then stringLiteral( quote1, escape )
            else if currChar = quote2 then stringLiteral( quote2, escape )
            else                           copyAndNext
        end while_not_at_eof
    end stripBlockComments ;
    % text stripBlockComments for C-style source                              %
    stripBlockComments( "/*", "*/", """", "'", "\" )
end.
