begin
    % verify expressions match expected syntax                                %
    procedure stmt ( string(256) value text ) ; begin
        % the parsing procedures return true if the expression matches the    %
        % required element, false otherwise - a parse tree is not built       %
        logical     haveInteger, haveIdentifier, haveEof, hadError;
        integer     currPos, maxPos, syPos;
        string(1)   currCh;
        string(256) srcText;
        string(256) sy;
        logical procedure expr ; expr_level_2;
        logical procedure expr_level_2 ; begin
            logical ok;
            ok := expr_level_3;
            while ok and have( "or" ) do ok := next and expr_level_3;
            ok
        end expr_level_2 ;
        logical procedure expr_level_3 ; begin
            logical ok;
            ok := expr_level_4;
            while have( "and" ) and ok do ok := next and expr_level_4;
            ok
        end expr_level_3 ;
        logical procedure expr_level_4 ; begin
            logical ok;
            ok := true;
            if have( "not" ) then ok := next;
            if ok then ok := expr_level_5;
            if ok and ( have( "=" ) or have( "<" ) ) then ok := next and expr_level_5;
            ok
        end expr_level_4 ;
        logical procedure expr_level_5 ; begin
            logical ok;
            ok := expr_level_6;
            while ok and ( have( "+" ) or have( "-" ) ) do ok := next and expr_level_6;
            ok
        end expr_level_5 ;
        logical procedure expr_level_6 ; begin
            logical ok;
            ok := primary;
            while ok and ( have( "*" ) or have( "/" ) ) do ok := next and primary;
            ok
        end expr_level_6 ;
        logical procedure primary ;
            if haveIdentifier or haveInteger or have( "true" ) or have( "false" ) then begin
                void( next );
                true
                end
            else if have( "(" ) then next and expr and mustBe( ")" )
            else error( "Expecting identifier, literal or ""(""" ) ;
        logical procedure addAndNextChar ; begin
            if syPos = 255 then void( error( "Symbol too long" ) )
            else if syPos < 255 then begin
                sy( syPos // 1 ) := currCh;
                syPos := syPos + 1
            end if_syPos_eq_255__lt_255 ;
            nextChar
        end addAndNextChar ;
        logical procedure next ; begin
            logical ok;
            haveInteger := haveIdentifier := false;
            ok          := skipSpaces;
            sy          := "";
            syPos       := 0;
            if not ok then sy := "<eof>"
            else begin
                if haveDigit then begin
                    haveInteger := true;
                    while addAndNextChar and haveDigit do begin end
                    end
                else if haveLetter then begin
                    while addAndNextChar and ( haveLetter or haveDigit or currCh = "_" ) do begin end;
                    haveIdentifier := sy not = "and" and sy not = "or" and sy not = "not" and sy not = "true" and sy not = "false"
                    end
                else void( addAndNextChar );
            end if_not_ok__ ;
            ok
        end next ;
        logical procedure skipSpaces ; begin
            logical ok;
            ok := not haveEof;
            while ok and currCh = " " do ok := nextChar;
            ok
        end skipSpaces ;
        logical procedure haveLetter ; not haveEof and (  ( currCh >= "a" and currCh <= "z" )
                                                       or ( currCh >= "A" and currCh <= "Z" ) );
        logical procedure haveDigit  ; not haveEof and (    currCh >= "0" and currCh <= "9" );
        logical procedure have   ( string(12) value text ) ; text = sy;
        logical procedure mustBe ( string(12) value text ) ; begin
            logical ok;
            ok := have( text );
            if ok then void( next )
            else begin
                string(256) msg;
                msg := "Expected:";
                msg( strlen( msg ) + 2 // 12 ) := text;
                void( error( msg ) )
            end if_ok;
            ok
        end mustBe ;
        logical procedure nextChar ; begin
            haveEof := currPos > maxPos;
            if not haveEof then begin
                currCh  := srcText( currPos // 1 );
                currPos := currPos + 1
            end if_not_haveEof ;
            not haveEof
        end nextChar ;
        integer procedure strlen ( string(256) value text ) ; begin
            integer length;
            length := 255;
            while length >= 0 and text( length // 1 ) = " " do length := length - 1;
            length
        end strlen ;
        logical procedure error ( string(256) value msg ) ; begin
            if not hadError then begin
                % have the first error %
                writeon( " error at: ", I_W := 1, currPos, "(" );
                showText( sy, strlen( sy ) );
                writeon( "): " );
                showText( msg, strlen( msg ) );
                hadError := true
            end if_not_hadError ;
            false
        end ewrror ;
        procedure showText ( string(256) value text; integer value length ) ; for c := 0 until length do writeon( text( c // 1 ) );
        procedure void ( logical value b ) ; begin end void ;
        % parse text and output messages indicating whether it is OK or not %
        hadError := false;
        sy       := "<bof>";
        srcText  := text;
        currPos  := 0;
        maxPos   := strlen( srcText );
        write();
        showText( srcText, maxPos );
        writeon( ": " );
        if not nextChar               then void( error( "Blank source text"             ) )
        else if not ( next and expr ) then void( error( "Expression expected"           ) )
        else if not haveEof           then void( error( "Expected EOF after expression" ) );
        if hadError then writeon( " false" )
        else             writeon( " true"  )
    end stmt ;
    % test cases %
    stmt( "wombat" );
    stmt( "wombat or monotreme" );
    stmt( "( wombat and not )" );
    stmt( "wombat or not" );
    stmt( "a + 1" );
    stmt( "a + b < c" );
    stmt( "a + b - c * d / e < f and not ( g = h )" );
    stmt( "a + b - c * d / e < f and not ( g = h" );
    stmt( "a = b" );
    stmt( "a or b = c" );
    stmt( "$" );
    % test cases from Go %
    stmt( "true or false = not true" );
    stmt( "not true = false" );
    stmt( "3 + not 5" );
    stmt( "3 + (not 5)" );
    stmt( "(42 + 3" );
    stmt( " not 3 < 4 or (true or 3 /  4 + 8 *  5 - 5 * 2 < 56) and 4 * 3  < 12 or not true" );
    stmt( " and 3 < 2" );
    stmt( "not 7 < 2" );
    stmt( "2 < 3 < 4" );
    stmt( "2 < foobar - 3 < 4" );
    stmt( "2 < foobar and 3 < 4" );
    stmt( "4 * (32 - 16) + 9 = 73" );
    stmt( "235 76 + 1" );
    stmt( "a + b = not c and false" );
    stmt( "a + b = (not c) and false" );
    stmt( "a + b = (not c and false)" );
    stmt( "ab_c / bd2 or < e_f7" );
    stmt( "g not = h" );
    stmt( "été = false" );
    stmt( "i++" );
    stmt( "j & k" );
    stmt( "l or _m" )
end.
