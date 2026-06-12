begin
    % extracts a file-extension from the end of a pathname.                   %
    % The file extension is defined as a dot followed by one or more letters  %
    % or digits. As Algol W only has fixed length strings we limit the        %
    % extension to 32 characters and the pathname to 256 (the longest string  %
    % allowed by Algol W)                                                     %
    string(32) procedure extension( string(256) value pathname ) ;
    begin

        integer pathPos;

        % position to the previous character in the pathname                  %
        procedure prev         ; pathPos := pathPos - 1;
        % get the character as pathPos from pathname                          %
        string(1) procedure ch ; pathname( pathPos // 1 );
        % checks for a letter or digit - assumes the letters are contiguous   %
        % in the character set - not true for EBCDIC                          %
        logical   procedure isLetterOrDigit( string(1) value c ) ;
                  ( c <= "z" and c >= "a" ) or ( c <= "Z" and c >= "A" )
                                            or ( c <= "9" and c >= "0" ) ;

        % find the length of the pathname with trailing blanks removed        %
        pathPos := 255;
        while pathPos >= 0 and ch = " " do prev;

        % extract the extension if possible                                   %
        if pathPos <= 0
        then ""       % no extension: 0 or 1 character pathname               %
        else if not isLetterOrDigit( ch )
        then ""       % no extension: last character not a letter/digit       %
        else begin
            while pathPos > 0 and isLetterOrDigit( ch ) do prev;
            if ch not = "."
            then ""   % no extension: letters/digits not preceeded by "."     %
            else begin
                % have an extension                                           %
                string(32) ext;
                ext := " ";
                % algol W substring lengths must be compile-time constants    %
                % hence the loop to copy the extension characters             %
                for charPos := 0 until 31 do begin
                    if pathPos <= 255 then begin
                        ext( charPos // 1 ) := pathname( pathPos // 1 );
                        pathPos := pathPos + 1
                    end
                end for_charPos ;
                ext
            end
        end

    end extension ;


    % test the extension procedure                                            %
    procedure testExtension( string(256) value pathname
                           ; string(32)  value expectedExtension
                           ) ;
    begin
        string(32) ext;
        ext := extension( pathname );
        write( pathname( 0 // 40 )
             , " -> ("
             , ext( 0 // 16 )
             , ") "
             , if ext = expectedExtension then "" else "NOT"
             , " as expected"
             )
    end ; % text extension %

    testExtension( "http://example.com/download.tar.gz", ".gz"      );
    testExtension( "CharacterModel.3DS",                 ".3DS"     );
    testExtension( ".desktop",                           ".desktop" );
    testExtension( "document",                           ""         );
    testExtension( "document.txt_backup",                ""         );
    testExtension( "/etc/pam.d/login",                   ""         );

end.
