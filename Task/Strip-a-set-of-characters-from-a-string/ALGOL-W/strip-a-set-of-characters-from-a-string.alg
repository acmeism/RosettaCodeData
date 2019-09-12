begin
    % returns s with the characters in remove removed                         %
    %     as all strings in Algol W are fixed length, the length of remove    %
    %     must be specified in removeLength                                   %
    string(256) procedure stripCharacters( string(256) value s, remove
                                         ; integer     value removeLength
                                         ) ;
    begin
        string(256) resultText;
        integer     tPos;
        resultText := " ";
        tPos := 0;
        for sPos := 0 until 255 do begin
            logical   keepCharacter;
            string(1) c;
            c             := s( sPos // 1 );
            keepCharacter := true;
            for rPos := 0 until removeLength - 1 do begin
                if remove( rPos // 1 ) = c then begin
                    % have a character that should be removed                 %
                    keepCharacter := false;
                    goto endSearch
                end if_have_a_character_to_remove ;
            end for_rPos ;
endSearch:
            if keepCharacter then begin
                resultText( tPos // 1 ) := c;
                tPos                    := tPos + 1
            end if_keepCharacter
        end for_sPos ;
        resultText
    end stripCharacters ;
    % task test case                                                          %
    begin
        string(256) ex, stripped;
        ex       := "She was a soul stripper. She took my heart!";
        stripped := stripCharacters( ex, "aei", 3 );
        write( "text: ",       ex( 0 // 64 ) );
        write( "  ->: ", stripped( 0 // 64 ) )
    end
end.
