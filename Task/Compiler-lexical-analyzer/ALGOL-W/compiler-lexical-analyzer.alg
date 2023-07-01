begin
    %lexical analyser %
    % Algol W strings are limited to 256 characters in length so we limit source lines %
    % and tokens to 256 characters %

    integer     lineNumber, columnNumber;
    string(256) line;
    string(256) tkValue;
    integer     tkType, tkLine, tkColumn, tkLength, tkIntegerValue;
    logical     tkTooLong;
    string(1)   currChar;
    string(1)   newlineChar;

    integer     LINE_WIDTH, MAX_TOKEN_LENGTH, MAXINTEGER_OVER_10, MAXINTEGER_MOD_10;
    integer     tOp_multiply   , tOp_divide        , tOp_mod       , tOp_add
          ,     tOp_subtract   , tOp_negate        , tOp_less      , tOp_lessequal
          ,     tOp_greater    , tOp_greaterequal  , tOp_equal     , tOp_notequal
          ,     tOp_not        , tOp_assign        , tOp_and       , tOp_or
          ,     tLeftParen     , tRightParen       , tLeftBrace    , tRightBrace
          ,     tSemicolon     , tComma            , tKeyword_if   , tKeyword_else
          ,     tKeyword_while , tKeyword_print    , tKeyword_putc , tIdentifier
          ,     tInteger       , tString           , tEnd_of_input , tComment
          ;

    string(16)  array tkName ( 1 :: 32 );

    % reports an error %
    procedure lexError( string(80) value message ); begin
        integer errorPos;
        write( i_w := 1, s_w := 0, "**** Error at(", lineNumber, ",", columnNumber, "): " );
        errorPos := 0;
        while errorPos < 80 and message( errorPos // 1 ) not = "." do begin
            writeon( s_w := 0, message( errorPos // 1 ) );
            errorPos := errorPos + 1
        end while_not_at_end_of_message ;
        writeon( s_w := 0, "." )
    end lexError ;

    % gets the next source character %
    procedure nextChar ; begin
        if      columnNumber = LINE_WIDTH then begin
            currChar     := newlineChar;
            columnNumber := columnNumber + 1
            end
        else if columnNumber > LINE_WIDTH then begin
            readcard( line );
            columnNumber := 1;
            if not XCPNOTED(ENDFILE) then lineNumber := lineNumber + 1;
            currChar     := line( 0 // 1 )
            end
        else begin
            currChar     := line( columnNumber // 1 );
            columnNumber := columnNumber + 1
        end
    end nextChar ;

    % gets the next token, returns the token type %
    integer procedure nextToken ; begin

        % returns true if currChar is in the inclusive range lowerValue to upperValue %
        %         false otherwise %
        logical procedure range( string(1) value lowerValue, upperValue ) ; begin
            currChar >= lowerValue and currChar <= upperValue
        end range ;

        % returns true if the current character can start an identifier, false otherwise %
        logical procedure identifierStartChar ; begin
            currChar = "_" or range( "a", "z" ) or range( "A", "Z" )
        end identifierStartChar ;

        % add the current character to the token and get the next %
        procedure addAndNextChar ; begin
            if tkLength >= MAX_TOKEN_LENGTH then tkTooLong := true
            else begin
                tkValue( tkLength // 1 ) := currChar;
                tkLength                 := tkLength + 1
            end if_symbol_not_too_long ;
            nextChar
        end % addAndNextChar % ;

        % handle a single character token %
        procedure singleCharToken( integer value tokenType ) ; begin
            tkType := tokenType;
            nextChar
        end singleCharToken ;

        % handle a doubled character token: && or || %
        procedure doubleCharToken( integer value tokenType ) ; begin
            string(1) firstChar;
            firstChar := currChar;
            tkType    := tokenType;
            nextChar;
            if currChar = firstChar then nextChar
            else % the character wasn't doubled % lexError( "Unrecognised character." );
        end singleCharToken ;

        % handle an operator or operator= token %
        procedure opOrOpEqual( integer value opToken, opEqualToken ) ; begin
            tkType := opToken;
            nextChar;
            if currChar = "=" then begin
                % have operator= %
                tkType := opEqualToken;
                nextChar
            end if_currChar_is_equal ;
        end opOrOpEqual ;

        % handle a / operator or /* comment %
        procedure divideOrComment ; begin
            tkType := tOp_divide;
            nextChar;
            if currChar = "*" then begin
                % have a comment %
                logical moreComment;
                tkType      := tComment;
                moreComment := true;
                while moreComment do begin
                    nextChar;
                    while currChar not = "*" and not XCPNOTED(ENDFILE) do nextChar;
                    while currChar     = "*" and not XCPNOTED(ENDFILE) do nextChar;
                    moreComment := ( currChar not = "/" and not XCPNOTED(ENDFILE) )
                end while_more_comment ;
                if not XCPNOTED(ENDFILE)
                then nextChar
                else lexError( "End-of-file in comment." )
            end if_currChar_is_star ;
        end divideOrComment ;

        % handle an indentifier or keyword %
        procedure identifierOrKeyword ; begin
            tkType := tIdentifier;
            while identifierStartChar or range( "0", "9" ) do addAndNextChar;
            % there are only 5 keywords, so we just test each in turn here %
            if      tkValue = "if"      then tkType  := tKeyword_if
            else if tkValue = "else"    then tkType  := tKeyword_else
            else if tkValue = "while"   then tkType  := tKeyword_while
            else if tkValue = "print"   then tkType  := tKeyword_print
            else if tkValue = "putc"    then tkType  := tKeyword_putc;
            if tkType not = tIdentifier then tkValue := "";
        end identifierOrKeyword ;

        % handle an integer literal %
        procedure integerLiteral ; begin
            logical overflowed;
            integer digit;
            overflowed := false;
            tkType     := tInteger;
            while range( "0", "9" ) do begin
                digit := ( decode( currChar ) - decode( "0" ) );
                if      tkIntegerValue > MAXINTEGER_OVER_10 then overflowed := true
                else if tkIntegerValue = MAXINTEGER_OVER_10
                    and digit          > MAXINTEGER_MOD_10  then overflowed := true
                else begin
                    tkIntegerValue := tkIntegerValue * 10;
                    tkIntegerValue := tkIntegerValue + digit;
                end;
                nextChar
            end while_have_a_digit ;
            if overflowed          then lexError( "Number too large." );
            if identifierStartChar then lexError( "Number followed by letter or underscore." );
        end integerLiteral ;

        % handle a char literal %
        procedure charLiteral ; begin
            nextChar;
            if      currChar = "'" or currChar = newlineChar then lexError( "Invalid character constant." )
            else if currChar = "\" then begin
                % have an escape %
                nextChar;
                if      currChar     = "n" then currChar := newlineChar
                else if currChar not = "\" then lexError( "Unknown escape sequence." )
            end;
            tkType         := tInteger;
            tkIntegerValue := decode( currChar );
            % should have a closing quoute next %
            nextChar;
            if   currChar not = "'"
            then lexError( "Multi-character constant." )
            else nextChar
        end charLiteral ;

        % handle a string literal %
        procedure stringLiteral ; begin
            tkType            := tString;
            tkValue( 0 // 1 ) := currChar;
            tkLength          := 1;
            nextChar;
            while currChar not = """" and currChar not = newlineChar and not XCPNOTED(ENDFILE) do addAndNextChar;
            if      currChar = newlineChar then lexError( "End-of-line while scanning string literal." )
            else if XCPNOTED(ENDFILE)      then lexError( "End-of-file while scanning string literal." )
            else    % currChar must be """" % addAndNextChar
        end stringLiteral ;

        while begin
            % skip white space %
            while ( currChar = " " or currChar = newlineChar ) and not XCPNOTED(ENDFILE) do nextChar;
            % get the token %
            tkLine         := lineNumber;
            tkColumn       := columnNumber;
            tkValue        := "";
            tkLength       := 0;
            tkIntegerValue := 0;
            tkTooLong      := false;
            if      XCPNOTED(ENDFILE)   then tkType := tEnd_of_input
            else if currChar = "*"      then singleCharToken( tOp_multiply )
            else if currChar = "/"      then divideOrComment
            else if currChar = "%"      then singleCharToken( tOp_mod      )
            else if currChar = "+"      then singleCharToken( tOp_add )
            else if currChar = "-"      then singleCharToken( tOp_subtract )
            else if currChar = "<"      then opOrOpEqual( tOp_less,    tOp_lessequal     )
            else if currChar = ">"      then opOrOpEqual( tOp_greater, tOp_greaterequal  )
            else if currChar = "="      then opOrOpEqual( tOp_assign,  tOp_equal         )
            else if currChar = "!"      then opOrOpEqual( tOp_not,     tOp_notequal      )
            else if currChar = "&"      then doubleCharToken( tOp_and     )
            else if currChar = "|"      then doubleCharToken( tOp_or      )
            else if currChar = "("      then singleCharToken( tLeftParen  )
            else if currChar = ")"      then singleCharToken( tRightParen )
            else if currChar = "{"      then singleCharToken( tLeftBrace  )
            else if currChar = "}"      then singleCharToken( tRightBrace )
            else if currChar = ";"      then singleCharToken( tSemicolon  )
            else if currChar = ","      then singleCharToken( tComma      )
            else if identifierStartChar then identifierOrKeyword
            else if range( "0", "9" )   then integerLiteral
            else if currChar = "'"      then charLiteral
            else if currChar = """"     then stringLiteral
            else begin
                lexError( "Unrecognised character." );
                singleCharToken( tComment )
            end ;
            % continue until we get something other than a comment %
            tkType = tComment
        end do begin end;
        if tkTooLong then if   tkType = tString
                          then lexError( "String literal too long." )
                          else lexError( "Identifier too long."     );
        tkType
    end nextToken ;

    % outputs the current token %
    procedure writeToken ; begin
        write( i_w := 5, s_w := 2, tkLine, tkColumn, tkName( tkType ) );
        if tkType = tInteger then writeon( i_w := 11, tkIntegerValue )
        else if tkLength > 0 then begin
            writeon( "  " );
            for tkPos := 0 until tkLength - 1 do writeon( s_w := 0, tkValue( tkPos // 1 ) );
        end
    end writeToken ;

    LINE_WIDTH       := 256; MAXINTEGER_MOD_10  := MAXINTEGER rem 10;
    MAX_TOKEN_LENGTH := 256; MAXINTEGER_OVER_10 := MAXINTEGER div 10;
    newlineChar      := code( 10 );
    tOp_multiply     :=  1; tkName( tOp_multiply     ) := "Op_multiply";
    tOp_divide       :=  2; tkName( tOp_divide       ) := "Op_divide";
    tOp_mod          :=  3; tkName( tOp_mod          ) := "Op_mod";
    tOp_add          :=  4; tkName( tOp_add          ) := "Op_add";
    tOp_subtract     :=  5; tkName( tOp_subtract     ) := "Op_subtract";
    tOp_negate       :=  6; tkName( tOp_negate       ) := "Op_negate";
    tOp_less         :=  7; tkName( tOp_less         ) := "Op_less";
    tOp_lessequal    :=  8; tkName( tOp_lessequal    ) := "Op_lessequal";
    tOp_greater      :=  9; tkName( tOp_greater      ) := "Op_greater";
    tOp_greaterequal := 10; tkName( tOp_greaterequal ) := "Op_greaterequal";
    tOp_equal        := 11; tkName( tOp_equal        ) := "Op_equal";
    tOp_notequal     := 12; tkName( tOp_notequal     ) := "Op_notequal";
    tOp_not          := 13; tkName( tOp_not          ) := "Op_not";
    tOp_assign       := 14; tkName( tOp_assign       ) := "Op_assign";
    tOp_and          := 15; tkName( tOp_and          ) := "Op_and";
    tOp_or           := 16; tkName( tOp_or           ) := "Op_or";
    tLeftParen       := 17; tkName( tLeftParen       ) := "LeftParen";
    tRightParen      := 18; tkName( tRightParen      ) := "RightParen";
    tLeftBrace       := 19; tkName( tLeftBrace       ) := "LeftBrace";
    tRightBrace      := 20; tkName( tRightBrace      ) := "RightBrace";
    tSemicolon       := 21; tkName( tSemicolon       ) := "Semicolon";
    tComma           := 22; tkName( tComma           ) := "Comma";
    tKeyword_if      := 23; tkName( tKeyword_if      ) := "Keyword_if";
    tKeyword_else    := 24; tkName( tKeyword_else    ) := "Keyword_else";
    tKeyword_while   := 25; tkName( tKeyword_while   ) := "Keyword_while";
    tKeyword_print   := 26; tkName( tKeyword_print   ) := "Keyword_print";
    tKeyword_putc    := 27; tkName( tKeyword_putc    ) := "Keyword_putc";
    tIdentifier      := 28; tkName( tIdentifier      ) := "Identifier";
    tInteger         := 29; tkName( tInteger         ) := "Integer";
    tString          := 30; tkName( tString          ) := "String";
    tEnd_of_input    := 31; tkName( tEnd_of_input    ) := "End_of_input";
    tComment         := 32; tkName( tComment         ) := "Comment";

    % allow the program to continue after reaching end-of-file %
    ENDFILE := EXCEPTION( false, 1, 0, false, "EOF" );
    % ensure the first call to nextToken reads the first line %
    lineNumber   := 0;
    columnNumber := LINE_WIDTH + 1;
    currChar     := " ";
    % get and print all tokens from standard input %
    while nextToken not = tEnd_of_input do writeToken;
    writeToken
end.
