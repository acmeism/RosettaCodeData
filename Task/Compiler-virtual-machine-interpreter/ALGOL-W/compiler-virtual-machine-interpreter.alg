begin % virtual machine interpreter %
    % string literals %
    string(256) array stringValue  ( 0 :: 256 );
    integer     array stringLength ( 0 :: 256 );
    integer     MAX_STRINGS;
    % op codes %
    integer     oFetch, oStore, oPush
          ,     oAdd,   oSub,   oMul, oDiv, oMod, oLt, oGt,   oLe,   oGe,   oEq,   oNe
          ,     oAnd,   oOr,    oNeg, oNot, oJmp, oJz, oPrtc, oPrts, oPrti, oHalt
          ;
    string(6)   array opName       ( 1 :: 24 );
    integer     OP_MAX;
    % code %
    string(1)   array byteCode     ( 0 :: 4096 );
    integer     nextLocation, MAX_LOCATION;
    % data %
    integer     array data         ( 0 :: 4096 );
    integer     dataSize, MAX_DATA, MAX_STACK;
    % tracing %
    logical     trace;

    % reports an error and stops %
    procedure rtError( string(80) value message ); begin
        integer errorPos;
        write( s_w := 0, "**** Runtime error: " );
        errorPos := 0;
        while errorPos < 80 and message( errorPos // 1 ) not = "." do begin
            writeon( s_w := 0, message( errorPos // 1 ) );
            errorPos := errorPos + 1
        end while_not_at_end_of_message ;
        writeon( s_w := 0, "." );
        assert( false )
    end genError ;

    oFetch :=  1; opName( oFetch ) := "fetch"; oStore :=  2; opName( oStore ) := "store"; oPush :=  3; opName( oPush ) := "push";
    oAdd   :=  4; opName( oAdd   ) := "add";   oSub   :=  5; opName( oSub   ) := "sub";   oMul  :=  6; opName( oMul  ) := "mul";
    oDiv   :=  7; opName( oDiv   ) := "div";   oMod   :=  8; opName( oMod   ) := "mod";   oLt   :=  9; opName( oLt   ) := "lt";
    oGt    := 10; opName( oGt    ) := "gt";    oLe    := 11; opName( oLe    ) := "le";    oGe   := 12; opName( oGe   ) := "ge";
    oEq    := 13; opName( oEq    ) := "eq";    oNe    := 14; opName( oNe    ) := "ne";    oAnd  := 15; opName( oAnd  ) := "and";
    oOr    := 16; opName( oOr    ) := "or";    oNeg   := 17; opName( oNeg   ) := "neg";   oNot  := 18; opName( oNot  ) := "not";
    oJmp   := 19; opName( oJmp   ) := "jmp";   oJz    := 20; opName( oJz    ) := "jz";    oPrtc := 21; opName( oPrtc ) := "prtc";
    oPrts  := 22; opName( oPrts  ) := "prts";  oPrti  := 23; opName( oPrti  ) := "prti";  oHalt := 24; opName( oHalt ) := "halt";
    OP_MAX := oHalt;

    trace        := false;
    MAX_STACK    := 256;
    MAX_LOCATION := 4096;
    for pc := 0 until MAX_LOCATION do byteCode( pc ) := code( 0 );
    MAX_DATA := 4096;
    for dPos := 0 until MAX_DATA do data( dPos ) := 0;
    MAX_STRINGS := 256;
    for sPos := 0 until MAX_STRINGS do begin
        stringValue(  sPos ) := " ";
        stringLength( sPos ) := 0
    end for_sPos ;

    % load thge output from syntaxc analyser %
    begin % readCode %

        % skips spaces on the source line %
        procedure skipSpaces ; begin
            while line( lPos // 1 ) = " " do lPos := lPos + 1
        end skipSpaces ;

        % parses a string from line and stores it in the string literals table %
        procedure readString ( integer value stringNumber ) ; begin
            string(256) str;
            integer     sLen;
            str  := " ";
            sLen := 0;
            lPos := lPos + 1; % skip the opening double-quote %
            while lPos <= 255 and line( lPos // 1 ) not = """" do begin
                str( sLen // 1 ) := line( lPos // 1 );
                sLen := sLen + 1;
                lPos := lPos + 1
            end while_more_string ;
            if lPos > 255 then rtError( "Unterminated String." );
            % store the string %
            stringValue(  stringNumber ) := str;
            stringLength( stringNumber ) := sLen
        end readString ;

        % gets an integer from the line - checks for valid digits %
        integer procedure readInteger ; begin
            integer n;
            skipSpaces;
            n := 0;
            while line( lPos // 1 ) >= "0" and line( lPos // 1 ) <= "9" do begin
                n    := ( n * 10 ) + ( decode( line( lPos // 1 ) ) - decode( "0" ) );
                lPos := lPos + 1
            end while_not_end_of_integer ;
            n
        end readInteger ;

        % reads the next line from standard input %
        procedure readALine ; begin
            lPos := 0;
            readcard( line );
            if trace then write( s_w := 0, ">> ", line( 0 // 32 ) )
        end readALine ;

        % loads an instruction from the current source line %
        procedure loadCodeFromLine ; begin
            integer pc, opCode, operand, oPos;
            string(256) op;
            logical haveOperand;
            % get the code location %
            pc := readInteger;
            if pc > MAX_LOCATION then rtError( "Code too large." );
            % get the opCode %
            skipSpaces;
            oPos := 0;
            op := " ";
            while lPos <= 255 and line( lPos // 1 ) not = " " do begin
                op( oPos // 1 ) := line( lPos // 1 );
                oPos := oPos + 1;
                lPos := lPos + 1
            end while_more_opName ;
            % lookup the op code %
            opCode := 0;
            oPos   := 1;
            while oPos <= OP_MAX and opCode = 0 do begin
                if opName( oPos ) = op then opCode := oPos
                                       else oPos   := oPos + 1
            end while_op_not_found ;
            if opCode = 0 then rtError( "Unknown op code." );
            % get the operand if there is one %
            operand     := 0;
            haveOperand := false;
            if      opCode = oFetch or opCode = oStore then begin
                % fetch or store - operand is enclosed in square brackets %
                skipSpaces;
                if line( lPos // 1 ) not = "[" then rtError( """["" expected after fetch/store." );
                lPos        := lPos + 1;
                operand     := readInteger;
                if operand > dataSize then rtError( "fetch/store address out of range." );
                haveOperand := true
                end
            else if opCode = oPush then begin
                % push integer literal instruction %
                operand     := readInteger;
                haveOperand := true
                end
            else if opCode = oJmp or opCode = oJz then begin
                % jump - the operand is the relative address enclosed in parenthesis %
                % followed by the absolute address - we use the absolute address so  %
                % the opewrand will be >= 0 %
                skipSpaces;
                if line( lPos // 1 ) not = "(" then rtError( """("" expected after jmp/jz." );
                lPos        := lPos + 1;
                if line( lPos // 1 ) = "-" then % negative relative address % lPos := lPos + 1;
                operand     := readInteger;
                if line( lPos // 1 ) not = ")" then rtError( """)"" expected after jmp/jz." );
                lPos        := lPos + 1;
                operand     := readInteger;
                haveOperand := true
            end if_various_opcodes ;
            % store the code %
            byteCode( pc ) := code( opCode );
            if haveOperand then begin
                % have an operand for the op code %
                if ( pc + 4 ) > MAX_LOCATION then rtError( "Code too large." );
                for oPos := 1 until 4 do begin
                    pc := pc + 1;
                    byteCode( pc ) := code( operand rem 256 );
                    operand := operand div 256;
                end for_oPos
            end if_have_operand ;
        end loadCodeFromLine ;

        string(256) line;
        string(16)  name;
        integer     lPos, tPos, stringCount;

        % allow us to detect EOF %
        ENDFILE := EXCEPTION( false, 1, 0, false, "EOF" );

        % first line should be "Datasize: d Strings: s" where d = number variables %
        % and s = number of strings                                                %
        readALine;
        if line = "trace" then begin
            % extension - run in trace mode %
            trace := true;
            readALine
        end if_line_eq_trace ;
        if XCPNOTED(ENDFILE) then rtError( "Empty program file." );
        if line( 0 // 10 ) not = "Datasize: " then rtError( "Header line missing." );
        lPos := 10;
        dataSize := readInteger;
        if dataSize > MAX_DATA then rtError( "Datasize too large." );
        skipSpaces;
        if line( lPos // 9 ) not = "Strings: " then rtError( """Strings: "" missing on header line." );
        lPos := lPos + 9;
        stringCount := readInteger;
        if stringCount > MAX_STRINGS then rtError( "Too many strings." );
        % read the string table %
        for stringNumber := 0 until stringCount - 1 do begin
            string(256) str;
            integer     sLen, sPos;
            readALine;
            if XCPNOTED(ENDFILE) then rtError( "End-of-file in string table." );
            if line( lPos // 1 ) not = """" then rtError( "String literal expected." );
            str  := " ";
            sLen := 0;
            lPos := lPos + 1; % skip the opening double-quote %
            while lPos <= 255 and line( lPos // 1 ) not = """" do begin
                str( sLen // 1 ) := line( lPos // 1 );
                sLen := sLen + 1;
                lPos := lPos + 1
            end while_more_string ;
            if lPos > 255 then rtError( "Unterminated String." );
            % store the string %
            stringValue(  stringNumber ) := str;
            stringLength( stringNumber ) := sLen
        end for_sPos ;
        % read the code %
        readALine;
        while not XCPNOTED(ENDFILE) do begin
            if line not = " " then loadCodeFromLine;
            readALine
        end while_not_eof
    end;
    % run the program %
    begin
        integer pc, opCode, operand, sp;
        integer array st ( 0 :: MAX_STACK );
        logical halted;
        % prints a string from the string pool, escape sequences are interpreted %
        procedure writeOnString( integer value stringNumber ) ;
        begin
            integer     cPos, sLen;
            string(256) text;
            if stringNumber < 0 or stringNumber > MAX_STRINGS then rtError( "Invalid string number." );
            cPos := 0;
            sLen := stringLength( stringNumber );
            text := stringValue(  stringNumber );
            while cPos < stringLength( stringNumber ) do begin
                string(1) ch;
                ch := text( cPos // 1 );
                if ch not = "\" then writeon( s_w := 0, ch )
                else begin
                    % escaped character %
                    cPos := cPos + 1;
                    if cPos > sLen then rtError( "String terminates with ""\""." );
                    ch := text( cPos // 1 );
                    if ch = "n" then % newline % write()
                                else writeon( s_w := 0, ch )
                end;
                cPos := cPos + 1
            end while_not_end_of_string
        end writeOnString ;

        pc     := 0;
        sp     := -1;
        halted := false;
        while not halted do begin;
            % get the next op code and operand %
            opCode  := decode( byteCode( pc ) );
            pc      := pc + 1;
            operand := 0;
            if opCode = oFetch or opCode = oStore or opCode = oPush or opCode = oJmp or opCode = oJz then begin
                % this opCode has an operand %
                pc := pc + 4;
                for bPos := 1 until 4 do begin
                    operand := ( operand * 256 ) + decode( byteCode( pc - bPos ) );
                end for_bPos
            end if_opCode_with_an_operand ;
            if trace then begin
                write( i_w:= 1, s_w := 0, pc, " op(", opCode, "): ", opName( opCode ), " ", operand );
                write()
            end if_trace ;
            % interpret the instruction %
            if      opCode = oFetch then begin sp := sp + 1; st( sp ) := data( operand ) end
            else if opCode = oStore then begin data( operand ) := st( sp ); sp := sp - 1 end
            else if opCode = oPush  then begin sp := sp + 1; st( sp ) := operand         end
            else if opCode = oHalt  then halted := true
            else if opCode = oJmp   then pc     := operand
            else if oPCode = oJz    then begin
                if st( sp ) = 0 then pc := operand;
                sp := sp - 1
                end
            else if opCode = oPrtc  then begin writeon( i_w := 1, s_w := 0, code( st( sp ) ) ); sp := sp - 1 end
            else if opCode = oPrti  then begin writeon( i_w := 1, s_w := 0,       st( sp )   ); sp := sp - 1 end
            else if opCode = oPrts  then begin writeonString(                     st( sp )   ); sp := sp - 1 end
            else if opCode = oNeg   then st( sp ) := - st( sp )
            else if opCode = oNot   then st( sp ) := ( if st( sp ) = 0 then 1 else 0 )
            else begin
                operand := st( sp );
                sp      := sp - 1;
                if      opCode = oAdd   then st( sp ) :=    st( sp )    +  operand
                else if opCode = oSub   then st( sp ) :=    st( sp )    -  operand
                else if opCode = oMul   then st( sp ) :=    st( sp )    *  operand
                else if opCode = oDiv   then st( sp ) :=    st( sp )  div  operand
                else if opCode = oMod   then st( sp ) :=    st( sp )  rem  operand
                else if opCode = oLt    then st( sp ) := if st( sp )    <  operand then 1 else 0
                else if opCode = oGt    then st( sp ) := if st( sp )    >  operand then 1 else 0
                else if opCode = oLe    then st( sp ) := if st( sp )    <= operand then 1 else 0
                else if opCode = oGe    then st( sp ) := if st( sp )    >= operand then 1 else 0
                else if opCode = oEq    then st( sp ) := if st( sp )     = operand then 1 else 0
                else if opCode = oNe    then st( sp ) := if st( sp ) not = operand then 1 else 0
                else if opCode = oAnd   then st( sp ) := if st( sp ) not = 0 and operand not = 0 then 1 else 0
                else if opCode = oOr    then st( sp ) := if st( sp ) not = 0 or  operand not = 0 then 1 else 0
                else                         rtError( "Unknown opCode." )
            end if_various_opCodes
        end while_not_halted
    end
end.
