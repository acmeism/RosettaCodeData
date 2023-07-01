begin % syntax analyser %
    % parse tree nodes %
    record node( integer         type
               ; reference(node) left, right
               ; integer         iValue % nString/nIndentifier number or nInteger value %
               );
    integer     nIdentifier, nString, nInteger, nSequence, nIf,   nPrtc, nPrts
          ,     nPrti,       nWhile,  nAssign,  nNegate,   nNot,  nMultiply
          ,     nDivide,     nMod,    nAdd,     nSubtract, nLess, nLessEqual
          ,     nGreater,    nGreaterEqual,     nEqual,    nNotEqual,    nAnd, nOr
          ;
    string(14) array ndName ( 1 :: 25 );
    % tokens - names must match those output by the lexical analyser %
    integer     tkType, tkLine, tkColumn, tkLength, tkIntegerValue;
    integer     tOp_multiply   , tOp_divide        , tOp_mod       , tOp_add
          ,     tOp_subtract   , tOp_negate        , tOp_less      , tOp_lessequal
          ,     tOp_greater    , tOp_greaterequal  , tOp_equal     , tOp_notequal
          ,     tOp_not        , tOp_assign        , tOp_and       , tOp_or
          ,     tLeftParen     , tRightParen       , tLeftBrace    , tRightBrace
          ,     tSemicolon     , tComma            , tKeyword_if   , tKeyword_else
          ,     tKeyword_while , tKeyword_print    , tKeyword_putc , tIdentifier
          ,     tInteger       , tString           , tEnd_of_input
          ,     MAX_TOKEN_TYPE, PRIMARY_PREC
          ;
    string(16)  array tkName         ( 1 :: 31 );
    integer     array tkPrec, tkNode ( 1 :: 31 );
    % string literals and identifiers - uses a linked list - a hash table might be better... %
    string(1)   array text ( 0 :: 4095 );
    integer     textNext, TEXT_MAX;
    record textElement ( integer start, length; reference(textElement) next );
    reference(textElement) idList, stList;

    % returns a new node with left and right branches %
    reference(node) procedure opNode ( integer value opType; reference(node) value opLeft, opRight ) ; begin
        node( opType, opLeft, opRight, 0 )
    end opNode ;

    % returns a new operand node %
    reference(node) procedure operandNode ( integer value opType, opValue ) ; begin
        node( opType, null, null, opValue )
    end operandNode ;

    % reports an error %
    procedure synError( integer value line, column; string(80) value message ); begin
        integer errorPos;
        write( i_w := 1, s_w := 0, "**** Error at(", line, ",", column, "): " );
        errorPos := 0;
        while errorPos < 80 and message( errorPos // 1 ) not = "." do begin
            writeon( s_w := 0, message( errorPos // 1 ) );
            errorPos := errorPos + 1
        end while_not_at_end_of_message ;
        writeon( s_w := 0, "." )
    end synError ;

    % reports an error and stops %
    procedure fatalError( integer value line, column; string(80) value message ); begin
        synError( line, column, message );
        assert( false )
    end fatalError ;

    % prints a node and its sub-nodes %
    procedure writeNode( reference(node) value n ) ; begin
        % prints an identifier or string from text %
        procedure writeOnText( reference(textElement) value txHead; integer value txNumber ) ;
        begin
            reference(textElement) txPos;
            integer                count;
            txPos := txHead;
            count := 1;
            while count < txNumber and txPos not = null do begin
                txPos := next(txPos);
                count := count + 1
            end while_text_element_not_found ;
            if txPos = null then fatalError( 0, txNumber, "INTERNAL ERROR: text not found." )
            else for cPos := 0 until length(txPos) - 1 do writeon( text( start(txPos) + cPos ) );
            if text( start(txPos) ) = """" then writeon( """" );
        end writeOnText ;

        if n = null then write( ";" )
        else begin
            write( ndName( type(n) ) );
            if      type(n) = nInteger    then writeon( iValue(n) )
            else if type(n) = nIdentifier then writeOnText( idList, iValue(n) )
            else if type(n) = nString     then writeOnText( stList, iValue(n) )
            else begin
                writeNode(  left(n) );
                writeNode( right(n) )
            end
        end
    end writeNode ;

    % reads a token from standard input %
    procedure readToken ; begin

        % parses a string from line and stores it in a string in the text array %
        % - if it is not already present in the specified textElement list.     %
        % returns the position of the string in the text array                  %
        integer procedure readString ( reference(textElement) value result txList; string(1) value terminator ) ; begin
            string(256) str;
            integer     sLen, sPos, ePos;
            logical     found;
            reference(textElement) txPos, txLastPos;
            % get the text of the string %
            str  := " ";
            sLen := 0;
            str( sLen // 1 ) := line( lPos // 1 );
            sLen := sLen + 1;
            lPos := lPos + 1;
            while lPos <= 255 and line( lPos // 1 ) not = terminator do begin
                str( sLen // 1 ) := line( lPos // 1 );
                sLen := sLen + 1;
                lPos := lPos + 1
            end while_more_string ;
            if lPos > 255 then fatalError( tkLine, tkColumn, "Unterminated String in token file." );
            % attempt to find the text in the list of strings/identifiers %
            txLastPos := txPos := txList;
            found := false;
            ePos := 0;
            while not found and txPos not = null do begin
                ePos  := ePos + 1;
                found := ( length(txPos) = sLen );
                sPos  := 0;
                while found and sPos < sLen do begin
                    found := str( sPos // 1 ) = text( start(txPos) + sPos );
                    sPos  := sPos + 1
                end while_not_found ;
                txLastPos := txPos;
                if not found then txPos := next(txPos)
            end while_string_not_found ;
            if not found then begin
                % the string/identifier is not in the list - add it %
                ePos := ePos + 1;
                if txList = null then txList := textElement( textNext, sLen, null )
                                 else next(txLastPos) := textElement( textNext, sLen, null );
                if textNext + sLen > TEXT_MAX then fatalError( tkLine, tkColumn, "Text space exhausted." )
                else begin
                    for cPos := 0 until sLen - 1 do begin
                        text( textNext ) := str( cPos // 1 );
                        textNext := textNext + 1
                    end for_cPos
                end
            end if_not_found ;
            ePos
        end readString ;

        % gets an integer from the line - no checks for valid digits %
        integer procedure readInteger ; begin
            integer n;
            while line( lPos // 1 ) = " " do lPos := lPos + 1;
            n := 0;
            while line( lPos // 1 ) not = " " do begin
                n    := ( n * 10 ) + ( decode( line( lPos // 1 ) ) - decode( "0" ) );
                lPos := lPos + 1
            end while_not_end_of_integer ;
            n
        end readInteger ;

        string(256) line;
        string(16)  name;
        integer     lPos, tPos;
        tPos := lPos := 0;
        readcard( line );
        % get the line and column numbers %
        tkLine   := readInteger;
        tkColumn := readInteger;
        % get the token name %
        while line( lPos // 1 ) = " " do lPos := lPos + 1;
        name := "";
        while lPos < 256 and line( lPos // 1 ) not = " " do begin
            name( tPos // 1 ) := line( lPos // 1 );
            lPos := lPos + 1;
            tPos := tPos + 1
        end  while_more_name ;
        % determine the token type %
        tkType         := 1;
        tkIntegerValue := 0;
        while tkType <= MAX_TOKEN_TYPE and name not = tkName( tkType ) do tkType := tkType + 1;
        if tkType > MAX_TOKEN_TYPE then fatalError( tkLine, tkColumn, "Malformed token" );
        % handle the additional parameter for identifier/string/integer %
        if tkType = tInteger or tkType = tIdentifier or tkType = tString then begin
            while line( lPos // 1 ) = " " do lPos := lPos + 1;
            if      tkType = tInteger    then tkIntegerValue := readInteger
            else if tkType = tIdentifier then tkIntegerValue := readString( idList, " "  )
            else  % tkType = tString     %    tkIntegerValue := readString( stList, """" )
        end if_token_with_additional_parameter ;
    end readToken ;

    % parses a statement %
    reference(node) procedure parseStatement ; begin
        reference(node) stmtNode, stmtExpr;

        % skips the current token if it is expectedToken,              %
        % returns true if the token was expectedToken, false otherwise %
        logical procedure have ( integer value expectedToken ) ; begin
            logical haveExpectedToken;
            haveExpectedToken := ( tkType = expectedToken );
            if haveExpectedToken and tkType not = tEnd_of_input then readToken;
            haveExpectedToken
        end have ;

        % issues an error message and skips past the next semi-colon or to end of input %
        procedure skipStatement ( string(80) value message ) ; begin
            synError( tkLine, tkColumn, message );
            while tkType not = tEnd_of_input and not have( tSemicolon ) do readToken
        end skipStatement ;

        % checks we have a semicolon, issues an error and skips the statement if not %
        procedure mustBeEndOfStatement ; begin
            if not have( tSemicolon ) then skipStatement( """;"" expected." )
        end mustBeEndOfStatement ;

        % skips the current token if it is "(" and issues an error if it isn't %
        procedure mustBeLeftParen ; begin
            if not have( tLeftParen ) then synError( tkLine, tkColumn, """("" expected." )
        end % mustBeLeftParen % ;

        % skips the current token if it is ")" and issues an error if it isn't %
        procedure mustBeRightParen ; begin
            if not have( tRightParen ) then synError( tkLine, tkColumn, """)"" expected." )
        end % mustBeRightParen % ;

        % gets the next token and parses an expression with the specified precedence %
        reference(node) procedure nextAndparseExpr ( integer value precedence ) ; begin
            readToken;
            parseExpr( precedence )
        end nextAndParseExpr ;

        % parses an expression with the specified precedence %
        % all operators are assumed to be left-associative %
        reference(node) procedure parseExpr ( integer value precedence ) ; begin

            % handles a single token primary %
            reference(node) procedure simplePrimary ( integer value primaryNodeType ) ; begin
                reference(node) primaryNode;
                primaryNode := operandNode( primaryNodeType, tkIntegerValue );
                readToken;
                primaryNode
            end simplePrimary ;

            reference(node) exprNode;

            if precedence < PRIMARY_PREC  then begin
                exprNode := parseExpr( precedence + 1 );
                while tkPrec( tkType ) = precedence do begin
                    integer op;
                    op := tkNode( tkType );
                    exprNode := opNode( op, exprNode, nextAndParseExpr( precedence + 1 ) )
                end while_op_at_this_precedence_level
                end
            else if tkType = tIdentifier  then exprNode := simplePrimary( nIdentifier )
            else if tkType = tInteger     then exprNode := simplePrimary( nInteger    )
            else if tkType = nString      then begin
                synError( tkLine, tkColumn, "Unexpected string literal." );
                exprNode := simplePrimary( nInteger )
                end
            else if tkType = tLeftParen   then exprNode := parseParenExpr
            else if tkType = tOp_add      then exprNode := nextAndParseExpr( precedence )
            else if tkType = tOp_subtract then exprNode := opNode( nNegate, nextAndParseExpr( precedence ), null )
            else if tkType = tOp_not      then exprNode := opNode( nNot,    nextAndParseExpr( precedence ), null )
            else begin
                synError( tkLine, tkColumn, "Syntax error in expression." );
                exprNode := simplePrimary( nInteger )
            end;
            exprNode
        end parseExpr ;

        % parses a preenthesised expression %
        reference(node) procedure parseParenExpr ; begin
            reference(node) exprNode;
            mustBeLeftParen;
            exprNode := parseExpr( 0 );
            mustBeRightParen;
            exprNode
        end parseParenExpr ;

        % parse statement depending on it's first token %
        if      tkType = tIdentifier then begin % assignment statement %
            stmtExpr := operandNode( nIdentifier, tkIntegerValue );
            % skip the identifier and check for "=" %
            readToken;
            if not have( tOp_Assign ) then synError( tkLine, tkColumn, "Expected ""="" in assignment statement." );
            stmtNode := opNode( nAssign, stmtExpr, parseExpr( 0 ) );
            mustBeEndOfStatement
            end
        else if have( tKeyword_while ) then begin
            stmtExpr := parseParenExpr;
            stmtNode := opNode( nWhile, stmtExpr, parseStatement )
            end
        else if have( tkeyword_if ) then begin
            stmtExpr := parseParenExpr;
            stmtNode := opNode( nIf, stmtExpr, opNode( nIf, parseStatement, null ) );
            if have( tKeyword_else ) then % have an "else" part % right(right(stmtNode)) := parseStatement
            end
        else if have( tKeyword_Print ) then begin
            mustBeLeftParen;
            stmtNode := null;
            while begin
                if tkType = tString then begin
                    stmtNode  := opNode( nSequence, stmtNode, opNode( nPrts, operandNode( nString, tkIntegerValue ), null ) );
                    readToken
                    end
                else stmtNode := opNode( nSequence, stmtNode, opNode( nPrti, parseExpr( 0 ), null ) );
                have( tComma )
            end do begin end;
            mustBeRightparen;
            mustBeEndOfStatement;
            end
        else if have( tKeyword_Putc ) then begin
            stmtNode := opNode( nPrtc, parseParenExpr, null );
            mustBeEndOfStatement
            end
        else if have( tLeftBrace ) then begin % block %
            stmtNode := parseStatementList( tRightBrace );
            if not have( tRightBrace ) then synError( tkLine, tkColumn, "Expected ""}""." );
            end
        else if have( tSemicolon ) then stmtNode := null
        else begin % unrecognised statement %
            skipStatement( "Unrecognised statement." );
            stmtNode := null
        end if_various_tokens ;
        stmtNode
    end parseStatement ;

    % parses a statement list ending with the specified terminator %
    reference(node) procedure parseStatementList ( integer value terminator ) ; begin
        reference(node) listNode;
        listNode := null;
        while tkType not = terminator and tkType not = tEnd_of_input do listNode := opNode( nSequence, listNode, parseStatement );
        listNode
    end parseStatementList ;

    nIdentifier      :=  1; ndName( nIdentifier      ) := "Identifier";   nString    :=  2; ndName( nString   ) := "String";
    nInteger         :=  3; ndName( nInteger         ) := "Integer";      nSequence  :=  4; ndName( nSequence ) := "Sequence";
    nIf              :=  5; ndName( nIf              ) := "If";           nPrtc      :=  6; ndName( nPrtc     ) := "Prtc";
    nPrts            :=  7; ndName( nPrts            ) := "Prts";         nPrti      :=  8; ndName( nPrti     ) := "Prti";
    nWhile           :=  9; ndName( nWhile           ) := "While";        nAssign    := 10; ndName( nAssign   ) := "Assign";
    nNegate          := 11; ndName( nNegate          ) := "Negate";       nNot       := 12; ndName( nNot      ) := "Not";
    nMultiply        := 13; ndName( nMultiply        ) := "Multiply";     nDivide    := 14; ndName( nDivide   ) := "Divide";
    nMod             := 15; ndName( nMod             ) := "Mod";          nAdd       := 16; ndName( nAdd      ) := "Add";
    nSubtract        := 17; ndName( nSubtract        ) := "Subtract";     nLess      := 18; ndName( nLess     ) := "Less";
    nLessEqual       := 19; ndName( nLessEqual       ) := "LessEqual"  ;  nGreater   := 20; ndName( nGreater  ) := "Greater";
    nGreaterEqual    := 21; ndName( nGreaterEqual    ) := "GreaterEqual"; nEqual     := 22; ndName( nEqual    ) := "Equal";
    nNotEqual        := 23; ndName( nNotEqual        ) := "NotEqual";     nAnd       := 24; ndName( nAnd      ) := "And";
    nOr              := 25; ndName( nOr              ) := "Or";
    tOp_multiply     :=  1; tkName( tOp_multiply     ) := "Op_multiply";     tkPrec( tOp_multiply     ) :=  5;
    tOp_divide       :=  2; tkName( tOp_divide       ) := "Op_divide";       tkPrec( tOp_divide       ) :=  5;
    tOp_mod          :=  3; tkName( tOp_mod          ) := "Op_mod";          tkPrec( tOp_mod          ) :=  5;
    tOp_add          :=  4; tkName( tOp_add          ) := "Op_add";          tkPrec( tOp_add          ) :=  4;
    tOp_subtract     :=  5; tkName( tOp_subtract     ) := "Op_subtract";     tkPrec( tOp_subtract     ) :=  4;
    tOp_negate       :=  6; tkName( tOp_negate       ) := "Op_negate";       tkPrec( tOp_negate       ) := -1;
    tOp_less         :=  7; tkName( tOp_less         ) := "Op_less";         tkPrec( tOp_less         ) :=  3;
    tOp_lessequal    :=  8; tkName( tOp_lessequal    ) := "Op_lessequal";    tkPrec( tOp_lessequal    ) :=  3;
    tOp_greater      :=  9; tkName( tOp_greater      ) := "Op_greater";      tkPrec( tOp_greater      ) :=  3;
    tOp_greaterequal := 10; tkName( tOp_greaterequal ) := "Op_greaterequal"; tkPrec( tOp_greaterequal ) :=  3;
    tOp_equal        := 11; tkName( tOp_equal        ) := "Op_equal";        tkPrec( tOp_equal        ) :=  2;
    tOp_notequal     := 12; tkName( tOp_notequal     ) := "Op_notequal";     tkPrec( tOp_notequal     ) :=  2;
    tOp_not          := 13; tkName( tOp_not          ) := "Op_not";          tkPrec( tOp_not          ) := -1;
    tOp_assign       := 14; tkName( tOp_assign       ) := "Op_assign";       tkPrec( tOp_assign       ) := -1;
    tOp_and          := 15; tkName( tOp_and          ) := "Op_and";          tkPrec( tOp_and          ) :=  1;
    tOp_or           := 16; tkName( tOp_or           ) := "Op_or";           tkPrec( tOp_or           ) :=  0;
    tLeftParen       := 17; tkName( tLeftParen       ) := "LeftParen";       tkPrec( tLeftParen       ) := -1;
    tRightParen      := 18; tkName( tRightParen      ) := "RightParen";      tkPrec( tRightParen      ) := -1;
    tLeftBrace       := 19; tkName( tLeftBrace       ) := "LeftBrace";       tkPrec( tLeftBrace       ) := -1;
    tRightBrace      := 20; tkName( tRightBrace      ) := "RightBrace";      tkPrec( tRightBrace      ) := -1;
    tSemicolon       := 21; tkName( tSemicolon       ) := "Semicolon";       tkPrec( tSemicolon       ) := -1;
    tComma           := 22; tkName( tComma           ) := "Comma";           tkPrec( tComma           ) := -1;
    tKeyword_if      := 23; tkName( tKeyword_if      ) := "Keyword_if";      tkPrec( tKeyword_if      ) := -1;
    tKeyword_else    := 24; tkName( tKeyword_else    ) := "Keyword_else";    tkPrec( tKeyword_else    ) := -1;
    tKeyword_while   := 25; tkName( tKeyword_while   ) := "Keyword_while";   tkPrec( tKeyword_while   ) := -1;
    tKeyword_print   := 26; tkName( tKeyword_print   ) := "Keyword_print";   tkPrec( tKeyword_print   ) := -1;
    tKeyword_putc    := 27; tkName( tKeyword_putc    ) := "Keyword_putc";    tkPrec( tKeyword_putc    ) := -1;
    tIdentifier      := 28; tkName( tIdentifier      ) := "Identifier";      tkPrec( tIdentifier      ) := -1;
    tInteger         := 29; tkName( tInteger         ) := "Integer";         tkPrec( tInteger         ) := -1;
    tString          := 30; tkName( tString          ) := "String";          tkPrec( tString          ) := -1;
    tEnd_of_input    := 31; tkName( tEnd_of_input    ) := "End_of_input";    tkPrec( tEnd_of_input    ) := -1;
    MAX_TOKEN_TYPE   := 31; TEXT_MAX := 4095; textNext := 0; PRIMARY_PREC := 6;
    for tkPos := 1 until MAX_TOKEN_TYPE do tkNode( tkPos ) := - tkPos;
    tkNode( tOp_multiply     ) := nMultiply;  tkNode( tOp_divide   ) := nDivide;   tkNode( tOp_mod          ) := nMod;
    tkNode( tOp_add          ) := nAdd;       tkNode( tOp_subtract ) := nSubtract; tkNode( tOp_less         ) := nLess;
    tkNode( tOp_lessequal    ) := nLessEqual; tkNode( tOp_greater  ) := nGreater;  tkNode( tOp_greaterequal ) := nGreaterEqual;
    tkNode( tOp_equal        ) := nEqual;     tkNode( tOp_notequal ) := nNotEqual; tkNode( tOp_not          ) := nNot;
    tkNode( tOp_and          ) := nAnd;       tkNode( tOp_or       ) := nOr;
    stList := idList := null;

    % parse the output from the lexical analyser and output the linearised parse tree %
    readToken;
    writeNode( parseStatementList( tEnd_of_input ) )
end.
