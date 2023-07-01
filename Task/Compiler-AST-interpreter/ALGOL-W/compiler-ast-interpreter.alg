begin % AST interpreter %
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
    integer    MAX_NODE_TYPE;
    % string literals and identifiers - uses a linked list - a hash table might be better... %
    string(1)   array text ( 0 :: 4095 );
    integer     textNext, TEXT_MAX;
    record textElement ( integer start, length; reference(textElement) next );
    reference(textElement) idList, stList;
    % memory - identifiers hold indexes to locations here %
    integer array data ( 1 :: 4096 );

    % returns a new node with left and right branches %
    reference(node) procedure opNode ( integer value opType; reference(node) value opLeft, opRight ) ; begin
        node( opType, opLeft, opRight, 0 )
    end opNode ;

    % returns a new operand node %
    reference(node) procedure operandNode ( integer value opType, opValue ) ; begin
        node( opType, null, null, opValue )
    end operandNode ;

    % reports an error and stops %
    procedure rtError( string(80) value message ); begin
        integer errorPos;
        write( s_w := 0, "**** Runtime error " );
        errorPos := 0;
        while errorPos < 80 and message( errorPos // 1 ) not = "." do begin
            writeon( s_w := 0, message( errorPos // 1 ) );
            errorPos := errorPos + 1
        end while_not_at_end_of_message ;
        writeon( s_w := 0, "." );
        assert( false )
    end rtError ;

    % reads a node from standard input %
    reference(node) procedure readNode ; begin
        reference(node) resultNode;

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
            if lPos > 255 then rtError( "Unterminated String in node file." );
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
                if textNext + sLen > TEXT_MAX then rtError( "Text space exhausted." )
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
            n := 0;
            while line( lPos // 1 ) not = " " do begin
                n    := ( n * 10 ) + ( decode( line( lPos // 1 ) ) - decode( "0" ) );
                lPos := lPos + 1
            end while_not_end_of_integer ;
            n
        end readInteger ;

        string(256) line;
        string(16)  name;
        integer     lPos, tPos, ndType;
        tPos := lPos := 0;
        readcard( line );
        % get the node type name %
        while line( lPos // 1 ) = " " do lPos := lPos + 1;
        name := "";
        while lPos < 256 and line( lPos // 1 ) not = " " do begin
            name( tPos // 1 ) := line( lPos // 1 );
            lPos := lPos + 1;
            tPos := tPos + 1
        end  while_more_name ;
        % determine the node type %
        ndType         := 1;
        resultNode     := null;
        if name not = ";" then begin
            % not a null node %
            while ndType <= MAX_NODE_TYPE and name not = ndName( ndType ) do ndType := ndType + 1;
            if ndType > MAX_NODE_TYPE then rtError( "Malformed node." );
            % handle the additional parameter for identifier/string/integer, or sub-nodes for operator nodes %
            if ndType = nInteger or ndType = nIdentifier or ndType = nString then begin
                while line( lPos // 1 ) = " " do lPos := lPos + 1;
                if      ndType = nInteger    then resultNode := operandNode( ndType, readInteger )
                else if ndType = nIdentifier then resultNode := operandNode( ndType, readString( idList, " "  ) )
                else  % ndType = nString     %    resultNode := operandNode( ndType, readString( stList, """" ) )
                end
            else begin
                % operator node %
                reference(node) leftNode;
                leftNode   := readNode;
                resultNode := opNode( ndType, leftNode, readNode )
            end
        end if_non_null_node ;
        resultNode
    end readNode ;

    % interprets the specified node and returns the value %
    integer procedure eval ( reference(node) value n ) ; begin
        integer v;

        % prints a string from text, escape sequences are interpreted %
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
            if txPos = null then rtError( "INTERNAL ERROR: text not found." )
            else begin
                % found the text - output it, handling escape sequences %
                integer cPos;
                cPos := 1; % start from 1 to skip over the leading " %
                while cPos < length(txPos) do begin
                    string(1) ch;
                    ch := text( start(txPos) + cPos );
                    if ch not = "\" then writeon( s_w := 0, ch )
                    else begin
                        % escaped character %
                        cPos := cPos + 1;
                        if      cPos > length(txPos) then rtError( "String terminates with ""\""." )
                        else begin
                            ch := text( start(txPos) + cPos );
                            if ch = "n" then % newline % write()
                                        else writeon( s_w := 0, ch )
                        end
                    end;
                    cPos := cPos + 1
                end while_not_end_of_string
            end
        end writeOnText ;

        % returns 1 if val is true, 0 otherwise %
        integer procedure booleanResult ( logical value val ) ; begin
            if val then 1 else 0
        end booleanResult ;

        v := 0;

        if      n = null                 then v := 0
        else if type(n) = nIdentifier    then v := data( iValue(n) )
        else if type(n) = nString        then v := iValue(n)
        else if type(n) = nInteger       then v := iValue(n)
        else if type(n) = nSequence      then begin
            % sequence - evaluate and discard the left branch and return the right branch %
            v := eval(  left(n) );
            v := eval( right(n) )
            end
        else if type(n) = nIf            then % if-else         % begin
            if eval( left(n) ) not = 0 then v := eval(  left(right(n)) )
                                       else v := eval( right(right(n)) );
            v := 0
            end
        else if type(n) = nPrtc          then % print character % writeon( s_w := 0, code( eval( left(n) ) ) )
        else if type(n) = nPrts          then % print string    % writeOnText( stList, eval( left(n) ) )
        else if type(n) = nPrti          then % print integer   % writeon( s_w := 0, i_w := 1, eval( left(n) ) )
        else if type(n) = nWhile         then % while-loop      % begin
            while eval( left(n) ) not = 0 do v := eval( right(n) );
            v := 0
            end
        else if type(n) = nAssign        then % assignment      % data( iValue(left(n)) ) := eval( right(n) )
        else if type(n) = nNegate        then % unary -         % v := - eval( left(n) )
        else if type(n) = nNot           then % unary not       % v := booleanResult( eval( left(n) ) = 0 )
        else if type(n) = nMultiply      then % multiply        % v := eval( left(n) ) * eval( right(n) )
        else if type(n) = nDivide        then % division        % begin
            integer lv, rv;
            lv := eval(  left(n) );
            rv := eval( right(n) );
            if rv = 0 then rtError( "Division by 0." )
            else v := lv div rv
            end
        else if type(n) = nMod           then % modulo          % begin
            integer lv, rv;
            lv := eval(  left(n) );
            rv := eval( right(n) );
            if rv = 0 then rtError( "Right operand of % is 0." )
            else v := lv rem rv
            end
        else if type(n) = nAdd           then % addition        % v := eval( left(n) ) + eval( right(n) )
        else if type(n) = nSubtract      then % subtraction     % v := eval( left(n) ) - eval( right(n) )
        else if type(n) = nLess          then % less-than       % v := booleanResult( eval( left(n) ) <     eval( right(n) ) )
        else if type(n) = nLessEqual     then % less or equal   % v := booleanResult( eval( left(n) ) <=    eval( right(n) ) )
        else if type(n) = nGreater       then % greater-than    % v := booleanResult( eval( left(n) ) >     eval( right(n) ) )
        else if type(n) = nGreaterEqual  then % greater or eq   % v := booleanResult( eval( left(n) ) >=    eval( right(n) ) )
        else if type(n) = nEqual         then % test equal      % v := booleanResult( eval( left(n) ) =     eval( right(n) ) )
        else if type(n) = nNotEqual      then % not-equal       % v := booleanResult( eval( left(n) ) not = eval( right(n) ) )
        else if type(n) = nAnd           then % boolean "and"   % begin
            v := eval( left(n) );
            if v not = 0 then v := eval( right(n) )
            end
        else if type(n) = nOr            then % boolean "or"    % begin
            v := eval( left(n) );
            if v = 0 then v := eval( right(n) );
            end
        else % unknown node % begin
            rtError( "Unknown node type in eval." )
        end;
        v
    end eval ;

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
    MAX_NODE_TYPE    := 25; TEXT_MAX := 4095; textNext := 0;
    stList := idList := null;

    % parse the output from the syntax analyser and intetrpret parse tree %
    eval( readNode )
end.
