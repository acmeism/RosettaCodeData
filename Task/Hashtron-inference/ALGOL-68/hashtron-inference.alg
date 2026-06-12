BEGIN # Hashtron Inference - translated from the Go sample #

    # operators, modes, etc., to allow bit manipulation on unsigned INT values #
    # as Algol 68 doesn't have unsigned integers and we need to have values    #
    # bigger than 2^63, we use LONG INT (128 bit in Algol 68G)                 #
    # adjust to suit for other implementations                                 #
    MODE HINT = LONG INT;        # needs to be big enoungh for 2^63 + 1 #
    MODE HBIT = LONG BITS;
    HBIT b32  = 16rffffffff;     # 32-bit mask #
    OP   TOBITS = ( HINT a )HBIT: IF a >= 0 THEN BIN a ELSE NOT BIN ( - ( a + 1 ) ) FI;
    OP   TOBITS = ( INT  a )HBIT: TOBITS HINT( a );
    OP   TOINT  = ( HBIT a )HINT: IF 1 ELEM a THEN - ( ABS NOT a + 1 ) ELSE ABS a FI;
    PRIO ANDAB  = 1, ORAB = 1, XORAB = 1;
    OP   ANDAB  = ( REF HINT a, HINT b )REF HINT: a := TOINT ( TOBITS a AND TOBITS b );
    OP   ANDAB  = ( REF HINT a, INT  b )REF HINT: a ANDAB HINT( b );
    OP   ANDAB  = ( REF HINT a, HBIT b )REF HINT: a := TOINT ( TOBITS a AND b );
    OP   ORAB   = ( REF HINT a, HINT b )REF HINT: a := TOINT ( TOBITS a OR  TOBITS b );
    OP   XORAB  = ( REF HINT a, HINT b )REF HINT: a := TOINT ( TOBITS a XOR TOBITS b );
    OP   SHL    = ( HINT a, INT  b )HINT: TOINT ( TOBITS a SHL b );
    OP   SHL    = ( INT  a, INT  b )HINT: TOINT ( TOBITS HINT( a ) SHL b );
    OP   SHR    = ( HINT a, INT  b )HINT: TOINT ( TOBITS a SHR b );
    OP   OR     = ( HINT a, HINT b )HINT: TOINT ( TOBITS a OR TOBITS b );
    OP   AND    = ( HINT a, HBIT b )HINT: TOINT ( TOBITS a AND b );

    MODE PGM = STRUCT( INT low, high );
    PRIO H   = 9;
    OP   H   = ( INT a, b )PGM: ( a, b );

    PROC hash = ( HINT n, s, max )HINT:
         BEGIN
            # Mixing stage, mix input with salt using subtraction #
            HINT m := ( n - s ) AND b32;

            # Hashing stage, use xor shift with prime coefficients #
            m XORAB ( m SHL  2 ) AND b32;
            m XORAB ( m SHL  3 ) AND b32;
            m XORAB ( m SHR  5 ) AND b32;
            m XORAB ( m SHR  7 ) AND b32;
            m XORAB ( m SHL 11 ) AND b32;
            m XORAB ( m SHL 13 ) AND b32;
            m XORAB ( m SHR 17 ) AND b32;
            m XORAB ( m SHL 19 ) AND b32;

            # Mixing stage 2, mix input with salt using addition #
            m +:= s ANDAB b32;

            # Modular stage using Lemire's fast alternative to modulo reduction #
            ( ( m * max ) SHR 32 ) AND b32
         END # hash # ;

    PROC inference = ( HINT command, INT nbits, []PGM program in )HINT:
         IF   UPB program in < LWB program in
         THEN # the program is empty # 0
         ELSE
            HINT out := 0;
            # Iterate over the bits #
            []PGM program = program in[ AT 0 ];
            FOR j FROM 0 TO nbits - 1 DO
                HINT input := command OR ( j SHL 16 );
                PGM  pr0   = program[ 0 ];
                HINT ss    = low OF pr0;
                HINT maxx := high OF pr0;
                input := hash( input, ss, maxx );
                FOR i FROM 1 TO UPB program DO
                    PGM  pri = program[ i ];
                    HINT s   = low OF pri, max = high OF pri;
                    maxx   -:= max;
                    input   := hash( input, s, maxx )
                OD;
                input ANDAB 1;
                IF input /= 0 THEN
                    out ORAB 1 SHL j
                FI
            OD;
            out
         FI # inference # ;

    print( ( "Test Demo: ", whole( inference( 42, 64, 0H2 ), 0 ), newline ) );

    []PGM sq root
        = (     8776H79884,  12638H1259,  9953H1242,    4658H1228,    5197H1210
          ,    12043H1201,    6892H1183,  7096H1168,   10924H1149,    5551H1136
          ,     5580H1123,    3735H1107,  3652H1091,   12191H1076,   14214H1062
          ,    13056H1045,   14816H1031, 15205H1017,   10736H1001,    9804H989
          ,    13081H974,     6706H960,  13698H944,    14369H928,    16806H917
          ,     9599H906,     9395H897,   4885H883,    10237H870,    10676H858
          ,    18518H845,     2619H833,  13715H822,    11065H810,     9590H799
          ,     5747H785,     2627H776,   8962H764,     5575H750,     3448H738
          ,     5731H725,     9434H714,   3163H703,     3307H690,     3248H678
          ,     3259H667,     3425H657,   3506H648,     3270H639,     3634H627
          ,     3077H617,     3511H606,  27159H597,    27770H589,    28496H580
          ,    28481H571,    29358H562,  31027H552,    30240H543,    30643H534
          ,    31351H527,    31993H519,  32853H510,    33078H502,    33688H495
          ,    29732H487,    29898H480,  29878H474,    26046H468,    26549H461
          ,    28792H453,    26101H446,  32971H439,    29704H432,    23193H426
          ,    29509H421,    27079H415,  32453H409,    24737H404,    25725H400
          ,    23755H395,    52538H393,  53242H386,    19609H380,    26492H377
          ,    24566H358,    31163H368,  57174H363,    26639H364,    31365H357
          ,    60918H350,    21235H338,  28072H322,    28811H314,    27571H320
          ,    17635H309,    51968H169,  54367H323,    60541H254,    26732H270
          ,    52457H157,    27181H276,  19874H227,    22797H320,    59346H271
          ,    25496H260,    54265H231,  22281H250,    42977H318,    26008H240
          ,    87604H142,    94647H314,  52292H157,    20999H216,    89253H316
          ,    22746H29,     68338H312,  22557H317,   110904H104,    70975H285
          ,    51835H277,    51871H313, 132221H228,    18522H290,    68512H285
          ,   118816H302,   150865H268,  68871H273,    68139H290,    84984H285
          ,   150693H266,   396047H272,  84923H269,   215562H258,    68015H248
          ,   247689H235,   214471H229, 264395H221,   263287H212,   280193H201
          ,   108065H194,  263616H187,  148609H176,   263143H173,   378205H162
          ,   312547H154,   50400H147,  328927H140,   279217H132,   181111H127
          ,   672098H118,  657196H113,  459383H111,   833281H105,   520281H102
          ,   755397H95,   787994H91,   492444H82,   1016592H77,    656147H71
          ,   819893H66,   165531H61,   886503H57,   1016551H54,   3547827H49
          , 14398170H43,   395900H41,  4950628H37,  11481175H33, 100014881H30
          ,  8955328H31, 11313984H27, 13640855H23, 528553762H21,  63483027H17
          ,   952477H8,    950580H4,    918378H2,     918471H1
          );
    print( ( newline, "Square root demo for commands in [0..255]:", newline ) );
    FOR i FROM 0 TO 255 DO
        print( ( whole( inference( i, 4, sq root ), -3 ) ) );
        IF ( i + 1 ) MOD 16 = 0 THEN print( ( newline ) ) FI
    OD

END
