BEGIN # chemical calculator - calculate the molar mass of compounds                           #
    # MODE to hold element symbols and masses                                                 #
    MODE ATOM = STRUCT( STRING symbol, REAL mass, REF ATOM next );

    # returns the molar mass of the specified molecule #
    PROC molarmass = ( STRING molecule )REAL:
    BEGIN
        CHAR c;
        BOOL had error := FALSE;
        INT  ch max     = UPB molecule;
        INT  ch pos    := LWB molecule - 1;

        # reports a syntax error in the molecule starting at position ch pos                  #
        PROC error = ( STRING message )VOID:
        BEGIN
            print( ( "Syntax error in molecule: ", molecule, message, newline ) );
            print( ( "                          " ) );
            TO ch pos - 1 DO print( ( " " ) ) OD;
            print( ( "^", newline ) );
            # ensure parsing stops #
            had error := TRUE;
            ch pos    := ch max * 2
        END # error # ;
        # gets the next character from the molecule #
        PROC next char = VOID:
            c := IF ch pos +:= 1; ch pos > ch max THEN " " ELSE molecule[ ch pos ] FI;
        # parses a compound: a sequence of element names and bracketed compounds, each with   #
        # an optional trailing repeat count                                                   #
        PROC parse compound = REAL:
        BEGIN
            # parses an element symbol feom the molecule and returns its mass                 #
            PROC parse atom = REAL:
            BEGIN
                STRING symbol := c;
                next char;
                TO 2 WHILE c >= "a" AND c <= "z" DO
                    symbol +:= c;
                    next char
                OD;
                # find the element in the table #
                ATOM element := atoms[ ABS symbol[ LWB symbol ] - ABS "A" ];
                WHILE IF element IS REF ATOM(NIL) THEN FALSE ELSE symbol OF element /= symbol FI DO
                    element := next OF element
                OD;
                IF   element ISNT REF ATOM(NIL)
                THEN # found the element # mass OF element
                ELSE # unknown element #
                     ch pos -:= 1;
                     error( "Unrecognised element." );
                     0
                FI
            END # parse atom # ;
            REAL mass := 0;
            WHILE NOT had error AND ( ( c >= "A" AND c <= "Z" ) OR c = "(" ) DO
                REAL item mass := 0;
                IF   c >= "A" AND c <= "Z" THEN item mass := parse atom
                ELIF c = "(" THEN
                    # bracketed group #
                    next char;
                    item mass := parse compound;
                    IF IF ch pos > ch max THEN " " ELSE molecule[ ch pos ] FI /= ")" THEN
                        error( "Expected "")""." )
                    FI;
                    next char
                FI;
                IF c >= "0" AND c <= "9" THEN
                    # have a repeat count #
                    INT count := 0;
                    WHILE NOT had error AND c >= "0" AND c <= "9" DO
                        count *:= 10 +:= ABS c - ABS "0";
                        next char
                    OD;
                    item mass *:= count
                FI;
                mass +:= item mass
            OD;
            mass
        END # parse compound # ;
        next char;
        REAL compound mass = parse compound;
        IF ch pos <= ch max THEN error( "Unexpected text after the molecule." ) FI;
        compound mass
    END # molar mass # ;
    # hash table of atome, hash is the first character of the symbol - "A" #
    [ 0 : 25 ]REF ATOM atoms; FOR i FROM LWB atoms TO UPB atoms DO atoms( i ) := NIL OD;
    BEGIN # setup element symbols and masses as specified in the task #
        # adds an element and its mass to the atoms table #
        OP / = ( STRING symbol, REAL mass )VOID:
        BEGIN
            INT index = ABS symbol[ LWB symbol ] - ABS "A";
            atoms[ index ] := HEAP ATOM := ATOM( symbol, mass, atoms[ index ] )
        END # / # ;
        OP / = ( STRING symbol, INT  mass )VOID: symbol / REAL(mass);
        OP / = ( CHAR   symbol, REAL mass )VOID: STRING(symbol) / mass;
        PROC lanthanides = VOID:
        BEGIN
            "La"/138.90547;"Ce"/140.116 ;"Pr"/140.90766;"Nd"/144.242  ;"Pm"/145     ;
            "Sm"/150.36   ;"Eu"/151.964 ;"Gd"/157.25   ;"Tb"/158.92535;"Dy"/162.5   ;
            "Ho"/164.93033;"Er"/167.259 ;"Tm"/168.93422;"Yb"/173.054  ;"Lu"/174.9668;
            SKIP
        END # lanthanides # ;
        PROC actinides = VOID:
        BEGIN
            "Ac"/227      ;"Th"/232.0377;"Pa"/231.03588;"U" /238.02891;"Np"/237     ;
            "Pu"/244      ;"Am"/243     ;"Cm"/247;      "Bk"/247;      "Cf"/251     ;
            "Es"/252      ;"Fm"/257     ;#Md     ;       No     ;       Lr          ;#
            SKIP
        END # actinides # ;
        "H" /1.008   ;"Li"/ 6.94       ;"Na"/22.98976928 ;"K" /39.0983  ;"Rb"/85.4678  ;"Cs"/132.90545196;"Fr"/223 ;
                      "Be"/ 9.0121831  ;"Mg"/24.305      ;"Ca"/40.078   ;"Sr"/87.62    ;"Ba"/137.327     ;"Ra"/226 ;
                                                          "Sc"/44.955908;"Y" /88.90584 ;lanthanides      ;actinides;
                                                          "Ti"/47.867   ;"Zr"/91.224   ;"Hf"/178.49      ;# Rf     #
                                                          "V" /50.9415  ;"Nb"/92.90637 ;"Ta"/180.94788   ;# Db     #
                                                          "Cr"/51.9961  ;"Mo"/95.95    ;"W" /183.84      ;# Sg     #
                                                          "Mn"/54.938044;#Tc           #"Re"/186.207     ;# Bh     #
                                                          "Fe"/55.845   ;"Ru"/101.07   ;"Os"/190.23      ;# Hs     #
                                                          "Co"/58.933194;"Rh"/102.9055 ;"Ir"/192.217     ;# Mt     #
                                                          "Ni"/58.6934  ;"Pd"/106.42   ;"Pt"/195.084     ;# Ds     #
                                                          "Cu"/63.546   ;"Ag"/107.8682 ;"Au"/196.966569  ;# Rg     #
                                                          "Zn"/65.38    ;"Cd"/112.414  ;"Hg"/200.592     ;# Cn     #
                      "B" /10.81       ;"Al"/26.9815385  ;"Ga"/69.723   ;"In"/114.818  ;"Tl"/204.38      ;# Nh     #
                      "C" /12.011      ;"Si"/28.085      ;"Ge"/72.63    ;"Sn"/118.71   ;"Pb"/207.2       ;# Fl     #
                      "N" /14.007      ;"P" /30.973761998;"As"/74.921595;"Sb"/121.76   ;"Bi"/208.9804    ;# Ms     #
                      "O" /15.999      ;"S" / 32.06      ;"Se"/78.971   ;"Te"/127.6    ;"Po"/209         ;# Lv     #
                      "F" /18.998403163;"Cl"/35.45       ;"Br"/79.904   ;"I" /126.90447;"At"/210         ;# Ts     #
        "He"/4.002602;"Ne"/20.1797     ;"Ar"/39.948      ;"Kr"/83.798   ;"Xe"/131.293  ;"Rn"/222         ;# Og     #
        # --- hypothetical eigth period elements --/ #  "Uue"/315;"Ubn"/299;
        SKIP
    END;
    BEGIN # test cases #
        PROC test = ( REAL expected mass, STRING molecule )VOID:
        BEGIN
            REAL   mass = molar mass( molecule );
            STRING pad  = IF INT length = ( UPB molecule - LWB molecule ) + 1;
                             length > 20
                          THEN ""
                          ELSE ( 20 - length ) * " "
                          FI;
            print( ( newline, pad, molecule, ":", fixed( mass, -9, 3 ) ) );
            REAL diff = expected mass - mass;
            IF diff > 1e-12 OR diff < -1e-12 THEN
                print( ( " expected:", fixed( expected mass, -9, 3 ) ) )
            FI
        END # test # ;
        test( 1.008, "H" ); test( 2.016, "H2" );         test(  18.015, "H2O"   );
        test( 142.03553856000002, "Na2SO4"            ); test(  84.162, "C6H12" );
        test( 186.29499999999996, "COOH(C(CH3)2)3CH3" ); test( 350.45,  "UueCl" );
        print( ( newline ) )
    END
END
