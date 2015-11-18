begin

    % returns a list of the words contained in wordString, separated by ", ", %
    % except for the last which is separated from the rest by " and ".        %
    % The words are enclosed by braces                                        %
    string(256) procedure toList ( string(256) value  words ) ;
    begin
        string(256) list;
        integer     wordCount, wordNumber, listPos;
        logical     inWord;

        % returns true if ch is an upper-case letter, false otherwise         %
        %         assumes the letters are consecutive in the character set    %
        %         (as in ascii) would not be correct if the character set was %
        %         ebcdic (as in the original implementations of Algol W)      %
        logical procedure isUpper ( string(1) value ch ) ; ch >= "A" and ch <= "Z" ;

        % adds a character to the result                                      %
        procedure addChar( string(1) value ch ) ;
        begin
            list( listPos // 1 ) := ch;
            listPos := listPos + 1;
        end addChar ;

        % adds a string to the result                                        %
        procedure addString( string(256) value str
                           ; integer     value len
                           ) ;
            for strPos := 0 until len - 1 do addChar( str( strPos // 1 ) );

        % count the number of words                                           %

        wordCount := 0;
        inWord    := false;
        for charPos := 0 until 255
        do begin
            if isUpper( words( charPos // 1 ) ) then begin
                % not an upper-case letter, possibly a word has been ended    %
                inWord := false
                end
            else begin
                % not a delimitor, possibly the start of a word               %
                if not inWord then begin
                    % we are starting a new word                              %
                    wordCount := wordCount + 1;
                    inWord    := true
                end if_not_inWord
            end
        end for_charPos;

        % format the result                                                   %

        list       := "";
        listPos    := 0;
        inWord     := false;
        wordNumber := 0;

        addChar( "{" );

        for charPos := 0 until 255
        do begin
            if not isUpper( words( charPos // 1 ) ) then begin
                % not an upper-case letter, possibly a word has been ended    %
                inWord := false
                end
            else begin
                % not a delimitor, possibly the start of a word               %
                if not inWord then begin
                    % we are starting a new word                              %
                    wordNumber := wordNumber + 1;
                    inWord     := true;
                    if wordNumber > 1 then begin
                        % second or subsequent word - need a separator        %
                        if wordNumber = wordCount then addString( " and ", 5 ) % final word %
                                                  else addString( ", ",    2 ) % non-final word %
                    end
                end;
                % add the character to the result                             %
                addChar( words( charPos // 1 ) )
            end
        end for_charPos ;

        addChar( "}" );

        list
    end toList ;


    % procedure to test the toList procedure                                 %
    procedure testToList ( string(256) value words ) ;
    begin
        string(256) list;
        list := toList( words );
        write( s_w := 0
             , words( 0 // 32 )
             , ": "
             , list(  0 // 32 )
             )
    end testToList ;

    % test the toList procedure                                              %
    testToList( "" );
    testToList( "ABC" );
    testToList( "ABC DEF" );
    testToList( "ABC DEF G H" );

end.
