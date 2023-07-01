begin
    % determines the non-comment portion of the string s, startPos and endPos are   %
    % returned set to the beginning and ending character positions (indexed from 0) %
    % of the non-comment text in s. If there is no non-comment text in s, startPos  %
    % will be greater than endPos                                                   %
    % note that in Algol W, strings can be at most 256 characters long              %
    procedure stripComments ( string(256) value s; integer result startPos, endPos ) ;
    begin
        integer MAX_LENGTH;
        MAX_LENGTH := 256;
        startPos   :=  0;
        endPos     := -1;
        % find the first non-blank character in s %
        while startPos < MAX_LENGTH and s( startPos // 1 ) = " " do startPos := startPos + 1;
        if startPos < MAX_LENGTH then begin
            % have a non-blank character in the string %
            if s( startPos // 1 ) not = "#" and s( startPos // 1 ) not = ";" then begin
                % the non-blank character is not a comment delimiter %
                integer cPos;
                cPos := endPos := startPos;
                while cPos < MAX_LENGTH and s( cPos // 1 ) not = "#" and s( cPos // 1 ) not = ";" do begin
                    if s( cPos // 1 ) not = " " then endPos := cPos;
                    cPos := cPos + 1
                end while_not_a_comment
            end if_not_a_comment
        end if_startPos_lt_MAX_LENGTH
    end stripComments ;
    % tests the stripComments procedure                                             %
    procedure testStripComments( string(256) value s ) ;
    begin
        integer startPos, endPos;
        stripComments( s, startPos, endPos );
        write( """" );
        for cPos := startPos until endPos do writeon( s( cPos // 1 ) );
        writeon( """" )
    end testStripComments ;
    begin % test cases - should all print "apples, pears"                           %
        testStripComments( "apples, pears # and bananas" );
        testStripComments( "apples, pears ; and bananas" );
        testStripComments( "apples, pears "              );
        testStripComments( "              apples, pears" )
    end
end.
