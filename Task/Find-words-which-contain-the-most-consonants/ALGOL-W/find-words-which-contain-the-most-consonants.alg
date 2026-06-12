begin % find the words longer than 10 characters that contain most consonants %
    % an element of a WordList %
    record WordListElement ( string(32) w; reference(WordListElement) next );
    % structure to hold lists of words %
    record WordList ( reference(WordListElement) first, last );
    % lists of words indexed by number of consonants %
    reference(WordList) array words ( 1 :: 32 );
    string(32) word;
    integer aCode, aPos, ePos, iPos, oPos, uPos;
    for wPos := 1 until 32 do words( wPos ) := null;
    % allow the program to continue after reaching end-of-file %
    ENDFILE := EXCEPTION( false, 1, 0, false, "EOF" );
    % handle the input %
    aCode := decode( "a" );
    aPos  := 0;
    ePos  := decode( "e" ) - aCode;
    iPos  := decode( "i" ) - aCode;
    oPos  := decode( "o" ) - aCode;
    uPos  := decode( "u" ) - aCode;
    readcard( word );
    while not XCPNOTED(ENDFILE) do begin
        integer len;
        len   := 31;
        while len > 0 and word( len // 1 ) = " " do len := len - 1;
        len   := len + 1;
        if len > 10 then begin % word is at least 11 characters long %
            logical noRepeatedletters;
            integer consonants;
            integer array letterCount ( 0 :: 25 );
            for cPos := 0 until 25 do letterCount( cPos ) := 0;
            for cPos := 0 until len do begin
                integer c;
                c := decode( word( cPos // 1 ) ) - aCode;
                if c >= 0 and c <= 25 then % have a letter % letterCount( c ) := letterCount( c ) + 1;
            end for_cPos;
            % reset the vowel counts %
            letterCount( aPos ) := letterCount( ePos ) := letterCount( iPos ) := letterCount( oPos ) := letterCOunt( uPos ) := 0;
            % check at most 1 of each letter and at least one non-vowel %
            noRepeatedletters   := true;
            consonants          := 0;
            for cPos := 0 until 25 do begin
                if letterCount( cPos ) = 1 then consonants := consonants + 1
                else if letterCount( cPos ) > 1 then begin
                    % a repeated letter %
                    noRepeatedletters := false;
                    goto endLookFOrRepeatedLetters;
                end if_single_letter__repeated_letter
            end for_cPos ;
endLookFOrRepeatedLetters:
            if consonants > 0 and noRepeatedLetters then begin
                % have a word with more than 10 characters that has no repeated consonants %
                if words( consonants ) not = null then begin
                    % second or subsequent word with this many consonants %
                    last( words( consonants ) ) := next( last( words( consonants ) ) ) := WordListElement( word, null );
                    end
                else begin
                    % first word with this many consonants %
                    words( consonants ) := WordList( WordListElement( word, null ), null );
                    last( words( consonants ) ) := first( words( consonants ) )
                end if_words_consonants_ne_null__
            end if_have_no_repeated_consonants
        end if_len_gt_10 ;
        readcard( word );
    end while_not_eof ;
    % show the words %
    for wPos := 32 step -1 until 1 do begin
        if words( wPos ) not = null then begin
            % have words with wPos consonants %
            reference(WordListElement) rWord;
            integer wNumber;
            write( i_w := 1, s_w := 0,"Words with ", wPos, " consonants:" );
            rWord := first( words( wPos ) );
            wNumber := 0;
            while rWord not = null do begin
                if wNumber rem 5 = 0
                then write( "  ", w( rWord )( 0 // 18 ) )
                else writeon(     w( rWord )( 0 // 18 ) )
                ;
                wNumber := wNUmber + 1;
                rWord := next( rWord )
            end while_rWord_ne_null
        end if_words_wPos_ne_null
    end for_wPos
end.
