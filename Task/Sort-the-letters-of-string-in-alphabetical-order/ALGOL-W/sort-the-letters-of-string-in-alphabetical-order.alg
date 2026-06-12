begin
    % returns s with the letters sorted                           %
    %         as Algol W doesn't have variable length strings,    %
    %         the number of characters to sort must be specified  %
    %         in len                                              %
    string(256) procedure lSort( string(256) value s; integer value len ) ;
    begin
        string(256) letters, sortedS;
        integer lLen, lPos, u;
        sortedS := s;
        % get the letters %
        letters := "";
        lLen    := -1;
        for i := 0 until len - 1 do begin
            string(1) c;
            c := s( i // 1 );
            if ( c >= "a" and c <= "z" ) or ( c >= "A" and c <= "Z" ) then begin
                lLen := lLen + 1;
                letters( lLen // 1 ) := c
            end if_we_have_a_letter
        end for_i ;
        % bubble sort the letters %
        u := lLen;
        while begin
            logical sorted;
            sorted := true;
            u      := u - 1;
            for p := 0 until u do begin
                string(1) c, d;
                c := letters( p     // 1 );
                d := letters( p + 1 // 1 );
                if c > d then begin
                    letters( p     // 1 ) := d;
                    letters( p + 1 // 1 ) := c;
                    sorted                := false
                end if_c_gt_d
            end for_p ;
            not sorted
        end do begin end;
        % put the sorted letters into the result string %
        lPos := -1;
        for i := 0 until len - 1 do begin
            string(1) c;
            c := s( i // 1 );
            if ( c >= "a" and c <= "z" ) or ( c >= "A" and c <= "Z" ) then begin
                lpos := lPos + 1;
                sortedS( i // 1 ) := letters( lPos // 1 )
            end if_we_have_a_letter
        end for_i ;
        sortedS
    end lSort ;
    % prints the first len characters of s %
    procedure writeOnString( string(256) value s; integer value len ) ;
        for i := 0 until len - 1 do writeon( s_w := 0, s( i // 1 ) );
    % tests the lSort procedure %
    procedure testSort( string(256) value s; integer value len ) ;
    begin
        writeon( s_w := 0, "    [" );writeOnString(        s, len );        writeon( "]" );write();
        writeon( s_w := 0, " -> [" );writeOnString( lSort( s, len ), len ); writeon( "]" );write()
    end testSort ;

    testSort( "The quick brown fox jumps over the lazy dog, apparently", 55 );
    testSort( "Now is the time for all good men to come to the aid of their country.", 69 );
    testSort( "Stop! In the name of Wuv!", 25 )
end.
