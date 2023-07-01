BEGIN # execute some ComputerZero programs                                 #
    # instructions                                                         #
    INT nop = 0, lda = 1, sta = 2, add = 3, sub = 4, brz = 5, jmp = 6, stp = 7;
    PROC instr   = ( INT op, v )INT: ( 32 * op ) + v;
    OP NOP       = ( INT v     )INT: instr( nop, v );
    OP LDA       = ( INT v     )INT: instr( lda, v );
    OP STA       = ( INT v     )INT: instr( sta, v );
    OP ADD       = ( INT v     )INT: instr( add, v );
    OP SUB       = ( INT v     )INT: instr( sub, v );
    OP BRZ       = ( INT v     )INT: instr( brz, v );
    OP JMP       = ( INT v     )INT: instr( jmp, v );
    OP STP       = ( INT v     )INT: instr( stp, v );
    # executes the program named name                                      #
    PROC execute = ( STRING name, []INT program )VOID:
         BEGIN
            [ 0 : 31 ]INT m; # the computer 32 has bytes of memory         #
            FOR i FROM LWB m TO UPB m DO m[ i ] := 0 OD;
            # "assemble" the program                                       #
            INT m pos := -1;
            FOR i FROM LWB program TO UPB program DO
                m[ m pos +:= 1 ] := program[ i ]
            OD;
            # execute the program #
            BOOL running := TRUE;
            INT  pc      := 0;
            INT  a       := 0;
            WHILE running DO
                INT op      := m[ pc ] OVER 32;
                INT operand := m[ pc ] MOD  32;
                pc +:= 1 MODAB 32;
                IF   op = nop THEN SKIP
                ELIF op = lda THEN a  := m[ operand ]
                ELIF op = sta THEN m[ operand ] := a
                ELIF op = add THEN a +:= m[ operand ] MODAB 256
                ELIF op = sub THEN a -:= m[ operand ] MODAB 256
                ELIF op = brz THEN IF a = 0 THEN pc := operand FI
                ELIF op = jmp THEN pc := operand
                ELSE #    stp #
                    running := FALSE;
                    print( ( " " * ( 12 - ( ( UPB name - LWB name ) + 1 ) ) ) );
                    print( ( name, ": ", whole( a, -3 ), newline ) )
                FI
            OD
         END # execute # ;
    # task test programs (from the Computer Zero website)                  #
    # the unary NOP, LDA, STA, etc. operators are used to construct the    #
    # instructions; as parameterless operators aren't allowed, NOP and STP #
    # must have a dummy parameter                                          #
    execute( "2+2",  ( LDA  3, ADD  4, STP  0,      2,      2 )
           );
    execute( "7*8"
           , ( LDA 12, ADD 10, STA 12, LDA 11, SUB 13, STA 11, BRZ  8, JMP  0
             , LDA 12, STP  0,      8,      7,      0,      1
             )
           );
    execute( "fibonacci"
           , ( LDA 14, STA 15, ADD 13, STA 14, LDA 15, STA 13, LDA 16, SUB 17
             , BRZ 11, STA 16, JMP  0, LDA 14, STP  0,      1,      1,      0
             ,      8,      1
             )
           );
    execute( "linkedList"
           , ( LDA 13, ADD 15, STA  5, ADD 16, STA  7, NOP  0, STA 14, NOP  0
             , BRZ 11, STA 15, JMP  0, LDA 14, STP  0, LDA  0,      0,     28
             ,      1,      0,      0,      0,      6,      0,      2,     26
             ,      5,     20,      3,     30,      1,     22,      4,     24
             )
           );
    execute( "prisoner"
           , ( NOP  0, NOP  0, STP  0,      0, LDA  3, SUB 29, BRZ 18, LDA  3
             , STA 29, BRZ 14, LDA  1, ADD 31, STA  1, JMP  2, LDA  0, ADD 31
             , STA  0, JMP  2, LDA  3, STA 29, LDA  1, ADD 30, ADD  3, STA  1
             , LDA  0, ADD 30, ADD  3, STA  0, JMP  2,      0,      1,      3
             )
           );
    # subtractions yielding negative results                               #
    execute( "0-255", ( LDA  3, SUB  4, STP  0,      0,    255 ) );
    execute( "0-1",   ( LDA  3, SUB  4, STP  0,      0,      1 ) );
    # overflow on addition                                                 #
    execute( "1+255", ( LDA  3, ADD  4, STP  0,      1,    255 ) )
END
