begin % code generator %
    % parse tree nodes %
    record node( integer         type
               ; reference(node) left, right
               ; integer         iValue % nString/nIndentifier number or nInteger value %
               );
    integer    nIdentifier, nString, nInteger, nSequence, nIf,   nPrtc, nPrts
          ,    nPrti,       nWhile,  nAssign,  nNegate,   nNot,  nMultiply
          ,    nDivide,     nMod,    nAdd,     nSubtract, nLess, nLessEqual
          ,    nGreater,    nGreaterEqual,     nEqual,    nNotEqual,    nAnd, nOr
          ;
    string(14) array ndName ( 1 :: 25 );
    integer    array nOp    ( 1 :: 25 );
    integer    MAX_NODE_TYPE;
    % string literals and identifiers - uses a linked list - a hash table might be better... %
    string(1)  array text ( 0 :: 4095 );
    integer    textNext, TEXT_MAX;
    record textElement ( integer start, length; reference(textElement) next );
    reference(textElement) idList, stList;
    % op codes %
    integer    oFetch, oStore, oPush
          ,    oAdd,   oSub,   oMul, oDiv, oMod, oLt, oGt,   oLe,   oGe,   oEq,  oNe
          ,    oAnd,   oOr,    oNeg, oNot, oJmp, oJz, oPrtc, oPrts, oPrti, oHalt
          ;
    string(6)  array opName ( 1 :: 24 );
    % code - although this is intended to be byte code, as we are going to output    %
    %        an assembler source, we use integers for convenience                    %
    % labelLocations are: - ( referencing location + 1 ) if they have been referenced but not defined yet, %
    %                     zero     if they are unreferenced and undefined,                                 %
    %                     ( referencing location + 1 )   if they are defined                               %
    integer    array byteCode ( 0 :: 4095 );
    integer    array labelLocation( 1 :: 4096 );
    integer    nextLocation, MAX_LOCATION, nextLabelNumber, MAX_LABEL_NUMBER;

    % returns a new node with left and right branches %
    reference(node) procedure opNode ( integer value opType; reference(node) value opLeft, opRight ) ; begin
        node( opType, opLeft, opRight, 0 )
    end opNode ;

    % returns a new operand node %
    reference(node) procedure operandNode ( integer value opType, opValue ) ; begin
        node( opType, null, null, opValue )
    end operandNode ;

    % reports an error and stops %
    procedure genError( string(80) value message ); begin
        integer errorPos;
        write( s_w := 0, "**** Code generation error: " );
        errorPos := 0;
        while errorPos < 80 and message( errorPos // 1 ) not = "." do begin
            writeon( s_w := 0, message( errorPos // 1 ) );
            errorPos := errorPos + 1
        end while_not_at_end_of_message ;
        writeon( s_w := 0, "." );
        assert( false )
    end genError ;

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
            if lPos > 255 then genError( "Unterminated String in node file." );
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
                if textNext + sLen > TEXT_MAX then genError( "Text space exhausted." )
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
            if ndType > MAX_NODE_TYPE then genError( "Malformed node." );
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

    % returns the next free label number %
    integer procedure newLabel ; begin
        nextLabelNumber := nextLabelNumber + 1;
        if nextLabelNumber > MAX_LABEL_NUMBER then genError( "Program too complex" );
        nextLabelNumber
    end newLabel ;

    % defines the specified label to be at the next location %
    procedure defineLabel ( integer value labelNumber ) ; begin
        if labelLocation( labelNumber ) > 0 then genError( "Label already defined" )
        else begin
            % this is the first definition of the label, define it and if it has already been referenced, fill in the reference %
            integer currValue;
            currValue := labelLocation( labelNumber );
            labelLocation( labelNumber ) := nextLocation + 1; % we store pc + 1 to ensure the label location is positive %
            if currValue < 0 then % already referenced % byteCode( - ( currValue + 1 ) ) := labelLocation( labelNumber )
        end
    end defineLabel ;

    % stores a byte in the code %
    procedure genByte ( integer value byteValue ) ; begin
        if nextLocation > MAX_LOCATION then genError( "Program too large" );
        byteCode( nextLocation ) := byteValue;
        nextLocation := nextLocation + 1
    end genByte ;

    % stores an integer in the code %
    procedure genInteger ( integer value integerValue ) ; begin
        % we are storing the bytes of the code in separate integers for convenience %
        genByte( integerValue ); genByte( 0 ); genByte( 0 ); genByte( 0 )
    end genInteger ;

    % generates an operation acting on an address %
    procedure genDataOp ( integer value opCode, address ) ; begin
        genByte( opCode );
        genInteger( address )
    end genDataOp ;

    % generates a nullary operation %
    procedure genOp0  ( integer value opCode ) ; begin
        genByte( opCode )
    end genOp0 ;

    % generates a unary/binary operation %
    procedure genOp ( reference(node) value n ) ; begin
        gen(  left(n) );
        gen( right(n) ); % right will be null for a unary op so no code will be generated %
        genByte( nOp( type(n) ) )
    end genOp ;

    % generates a jump operation %
    procedure genJump   ( integer value opCode, labelNumber ) ; begin
        genByte( opCode );
        % if the label is not defined yet - set it's location to the negative of the referencing location %
        % so it can be resolved later %
        if labelLocation( labelNumber ) = 0 then labelLocation( labelNumber ) := - ( nextLocation + 1 );
        genInteger( labelLocation( labelNumber ) )
    end genJump ;

    % generates code for the node n %
    procedure gen ( reference(node) value n ) ; begin

        if           n  = null        then % empty node % begin end
        else if type(n) = nIdentifier then genDataOp( oFetch, iValue(n) )
        else if type(n) = nString     then genDataOp( oPush,  iValue(n) - 1 )
        else if type(n) = nInteger    then genDataOp( oPush,  iValue(n) )
        else if type(n) = nSequence   then begin
            gen(  left(n) );
            gen( right(n) )
            end
        else if type(n) = nIf         then % if-else         % begin
            integer elseLabel;
            elseLabel := newLabel;
            gen( left(n) );
            genJump( oJz, elseLabel );
            gen( left( right(n) ) );
            if right(right(n)) = null then % no "else" part % defineLabel( elseLabel )
            else begin
                % have an "else" part %
                integer endIfLabel;
                endIfLabel := newLabel;
                genJump( oJmp, endIfLabel );
                defineLabel( elseLabel );
                gen( right(right(n)) );
                defineLabel( endIfLabel )
            end
            end
        else if type(n) = nWhile      then % while-loop      % begin
            integer loopLabel, exitLabel;
            loopLabel := newLabel;
            exitLabel := newLabel;
            defineLabel( loopLabel );
            gen(  left(n) );
            genJump( oJz,  exitLabel );
            gen( right(n) );
            genJump( oJmp, loopLabel );
            defineLabel( exitLabel )
            end
        else if type(n) = nAssign     then % assignment      % begin
            gen( right( n ) );
            genDataOp( oStore, iValue(left(n)) )
            end
        else genOp( n )
    end gen ;

    % outputs the generated code to standard output %
    procedure emitCode ; begin

        % counts the number of elements in a text element list %
        integer procedure countElements ( reference(textElement) value txHead ) ; begin
            integer count;
            reference(textElement) txPos;
            count := 0;
            txPos := txHead;
            while txPos not = null do begin
                count := count + 1;
                txPos := next(txPos)
            end while_txPos_not_null ;
            count
        end countElements ;

        integer pc, op;
        reference(textElement) txPos;

        % code header %
        write( i_w := 1, s_w := 0
             , "Datasize: ", countElements( idList )
             , " Strings: ", countElements( stList )
             );
        % output the string literals %
        txPos := stList;
        while txPos not = null do begin
            integer cPos;
            write( """" );
            cPos := 1; % start from 1 to skip over the leading " %
            while cPos < length(txPos) do begin
                writeon( s_w := 0, text( start(txPos) + cPos ) );
                cPos := cPos + 1
            end while_not_end_of_string ;
            writeon( s_w := 0, """" );
            txPos := next(txPos)
        end while_not_at_end_of_literals ;

        % code body %
        pc := 0;
        while pc < nextLocation do begin
            op := byteCode( pc );
            write( i_w := 4, s_w := 0, pc, " ", opName( op ) );
            pc := pc + 1;
            if      op = oFetch or op = oStore then begin
                % data load/store - add the address in square brackets %
                writeon( i_w := 1, s_w := 0, "[", byteCode( pc ) - 1, "]" );
                pc := pc + 4
                end
            else if op = oPush                 then begin
                % push constant - add the constant %
                writeon( i_w := 1, s_w := 0, byteCode( pc ) );
                pc := pc + 4
                end
            else if op = oJmp   or op = oJz    then begin
                % jump - show the relative address in brackets and the absolute address %
                writeon( i_w := 1, s_w := 0, "(", ( byteCode( pc ) - 1 ) - pc, ") ", byteCode( pc ) - 1 );
                pc := pc + 4
            end
        end while_pc_lt_nextLocation
    end emitCode ;

    oFetch :=  1; opName( oFetch ) := "fetch"; oStore :=  2; opName( oStore ) := "store"; oPush :=  3; opName( oPush ) := "push";
    oAdd   :=  4; opName( oAdd   ) := "add";   oSub   :=  5; opName( oSub   ) := "sub";   oMul  :=  6; opName( oMul  ) := "mul";
    oDiv   :=  7; opName( oDiv   ) := "div";   oMod   :=  8; opName( oMod   ) := "mod";   oLt   :=  9; opName( oLt   ) := "lt";
    oGt    := 10; opName( oGt    ) := "gt";    oLe    := 11; opName( oLe    ) := "le";    oGe   := 12; opName( oGe   ) := "ge";
    oEq    := 13; opName( oEq    ) := "eq";    oNe    := 14; opName( oNe    ) := "ne";    oAnd  := 15; opName( oAnd  ) := "and";
    oOr    := 16; opName( oOr    ) := "or";    oNeg   := 17; opName( oNeg   ) := "neg";   oNot  := 18; opName( oNot  ) := "not";
    oJmp   := 19; opName( oJmp   ) := "jmp";   oJz    := 20; opName( oJz    ) := "jz";    oPrtc := 21; opName( oPrtc ) := "prtc";
    oPrts  := 22; opName( oPrts  ) := "prts";  oPrti  := 23; opName( oPrti  ) := "prti";  oHalt := 24; opName( oHalt ) := "halt";

    nIdentifier      :=  1; ndName( nIdentifier   ) := "Identifier";   nString   :=  2; ndName( nString   ) := "String";
    nInteger         :=  3; ndName( nInteger      ) := "Integer";      nSequence :=  4; ndName( nSequence ) := "Sequence";
    nIf              :=  5; ndName( nIf           ) := "If";           nPrtc     :=  6; ndName( nPrtc     ) := "Prtc";
    nPrts            :=  7; ndName( nPrts         ) := "Prts";         nPrti     :=  8; ndName( nPrti     ) := "Prti";
    nWhile           :=  9; ndName( nWhile        ) := "While";        nAssign   := 10; ndName( nAssign   ) := "Assign";
    nNegate          := 11; ndName( nNegate       ) := "Negate";       nNot      := 12; ndName( nNot      ) := "Not";
    nMultiply        := 13; ndName( nMultiply     ) := "Multiply";     nDivide   := 14; ndName( nDivide   ) := "Divide";
    nMod             := 15; ndName( nMod          ) := "Mod";          nAdd      := 16; ndName( nAdd      ) := "Add";
    nSubtract        := 17; ndName( nSubtract     ) := "Subtract";     nLess     := 18; ndName( nLess     ) := "Less";
    nLessEqual       := 19; ndName( nLessEqual    ) := "LessEqual";    nGreater  := 20; ndName( nGreater  ) := "Greater";
    nGreaterEqual    := 21; ndName( nGreaterEqual ) := "GreaterEqual"; nEqual    := 22; ndName( nEqual    ) := "Equal";
    nNotEqual        := 23; ndName( nNotEqual     ) := "NotEqual";     nAnd      := 24; ndName( nAnd      ) := "And";
    nOr              := 25; ndName( nOr           ) := "Or";
    MAX_NODE_TYPE    := 25; TEXT_MAX := 4095; textNext := 0;
    stList := idList := null;
    for nPos := 1 until MAX_NODE_TYPE do nOp( nPos ) := -1;
    nOp( nPrtc     ) := oPrtc; nOp( nPrts      ) := oPrts; nOp( nPrti    ) := oPrti; nOp( nNegate       ) := oNeg; nOp( nNot      ) := oNot;
    nOp( nMultiply ) := oMul;  nOp( nDivide    ) := oDiv;  nOp( nMod     ) := oMod;  nOp( nAdd          ) := oAdd; nOp( nSubtract ) := oSub;
    nOp( nLess     ) := oLt;   nOp( nLessEqual ) := oLe;   nOp( nGreater ) := oGt;   nOp( nGreaterEqual ) := oGe;  nOp( nEqual    ) := oEq;
    nOp( nNotEqual ) := oNe;   nOp( nAnd       ) := oAnd;  nOp( nOr      ) := oOr;
    nextLocation     := 0; MAX_LOCATION := 4095;
    for pc := 0 until MAX_LOCATION do byteCode( pc ) := 0;
    nextLabelNumber := 0; MAX_LABEL_NUMBER := 4096;
    for lPos := 1 until MAX_LABEL_NUMBER do labelLocation( lPos ) := 0;

    % parse the output from the syntax analyser and generate code from the parse tree %
    gen( readNode );
    genOp0( oHalt );
    emitCode
end.
