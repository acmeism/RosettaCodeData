% determine whether we can spell words with a set of blocks                  %
begin
    % Returns true  if we can spell the word using the blocks,               %
    %         false otherwise                                                %
    % As strings are fixed length in Algol W, the length of the string is    %
    % passed as a separate parameter                                         %
    logical procedure canSpell ( string(20) value word
                               ; integer    value wordLength
                               ) ;
    begin

        % convert a character to upper-case                                  %
        % assumes the letters are contiguous in the character set            %
        % as in ASCII and Unicode - not correct for EBCDIC                   %
        string(1) procedure toUpper( string(1) value c ) ;
            if c < "a" or c > "z" then c
                                  else code( ( decode( c ) - decode( "a" ) )
                                           + decode( "A" )
                                           ) ;

        logical       spellable;
        integer       wordPos,  blockPos;
        string(20)    letters1, letters2;

        % make local copies the faces so we can remove the used blocks       %
        letters1 := face1;
        letters2 := face2;

        % check we can spell the word with the set of blocks                 %
        spellable := true;
        wordPos   := 0;
        while wordPos < wordLength and spellable do begin
            string(1) letter;
            letter    := toUpper( word( wordPos // 1 ) );
            if letter not = " " then begin
                spellable := false;
                blockPos  := 0;
                while blockPos < 20 and not spellable do begin
                    if letter = letters1( blockPos // 1 )
                    or letter = letters2( blockPos // 1 )
                    then begin
                        % found the letter - remove the used block from the  %
                        % remaining blocks                                   %
                        letters1( blockPos // 1 ) := " ";
                        letters2( blockPos // 1 ) := " ";
                        spellable := true
                    end;
                    blockPos := blockPos + 1
                end
            end;
            wordPos := wordPos + 1;
        end;

        spellable
    end canSpell ;

    % the letters available on the faces of the blocks                       %
    string(20) face1, face2;
    face1 := "BXDCNGRTQFJHVAOEFLPZ";
    face2 := "OKQPATEGDSWUINBRSYCM";

    begin
        % test the can spell procedure                                       %
        procedure testCanSpell ( string(20) value word
                               ; integer    value wordLength
                               ) ;
            write( if canSpell( word, wordLength ) then "can   " else "cannot"
                 , " spell """
                 , word
                 , """"
                 );

        testCanSpell( "a",       1 );
        testCanSpell( "bark",    4 );
        testCanSpell( "BOOK",    4 );
        testCanSpell( "treat",   5 );
        testCanSpell( "commoN",  6 );
        testCanSpell( "Squad",   5 );
        testCanSpell( "confuse", 7 )
    end
end.
