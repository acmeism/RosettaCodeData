BEGIN # Berlekamp–Massey algorithm - translation of the FreeBASIC sample     #

    INT mdl = 2;

    PROC fp = ( INT a, k )INT:
         BEGIN
            INT result := 1, bbase := a MOD mdl, expo := k;

            WHILE expo > 0 DO
                IF ODD expo THEN result *:= bbase MODAB mdl FI;
                bbase *:= bbase MODAB mdl;
                expo OVERAB 2
            OD;
            result
        END # fp # ;

    PROC berlekamp massey = ( []INT a in )[]INT:
         BEGIN
            [ 0 : -1 ]INT empty row;
            REF[]INT ans coef := empty row, lst := empty row;
            []INT a = a in[ AT 0 ];
            INT   n = UPB a;
            INT   lst size := 0, w := 0, delta := 0;

            FOR i TO n DO
                INT tmp := 0;
                INT ans len = UPB ans coef;
                FOR j FROM 0 TO ans len DO
                    IF i - 1 - j >= 1 THEN
                        tmp +:= ( a[ i - 1 - j ] * ans coef[ j ] ) MODAB mdl
                    FI
                OD;

                INT  discrepancy = ( a[ i ] - tmp + mdl ) MOD mdl;
                IF   discrepancy = 0
                THEN SKIP
                ELIF w = 0
                THEN
                    ans coef := HEAP[ 0 : i - 1 ]INT;
                    FOR j FROM 0 TO i - 1 DO ans coef[ j ] := 0 OD;
                    w     := i;
                    delta := discrepancy
                ELSE
                    [ 0 : UPB ans coef ]INT ahora := ans coef;

                    INT inv delta  = fp( delta, mdl - 2 );
                    INT mul        = ( discrepancy * inv delta ) MOD mdl;
                    INT needed len = lst size + i - w;

                    IF UPB ans coef + 1 < needed len THEN
                        ans coef := HEAP[ 0 : needed len - 1 ]INT;
                        ans coef[ 0 : UPB ahora AT 0 ] := ahora;
                        FOR j FROM UPB ahora + 1 TO UPB ans coef DO ans coef[ j ] := 0 OD
                    FI;

                    IF i - w - 1 >= 0 THEN
                        ans coef( i - w - 1 ) +:= mul MODAB mdl
                    FI;

                    FOR j FROM 0 TO lst size - 1 DO
                        INT idx = i - w + j;
                        IF idx < UPB ans coef  + 1 THEN
                            INT term to subtract = ( mul * lst[ j ] ) MOD mdl;
                            ans coef[ idx ] -:= term to subtract +:= mdl MODAB mdl
                        FI
                    OD;

                    IF UPB ans coef > UPB ahora THEN
                        lst := HEAP[ 0 : UPB ahora ]INT;
                        lst[ AT 0 ] := ahora;
                        lst size := UPB ahora + 1;
                        w := i;
                        delta := discrepancy
                    FI
                FI;

                FOR m FROM 0 TO UPB ans coef DO ans coef[ m ] +:= mdl MODAB mdl OD

            OD;
            ans coef
         END # berlekamp massey # ;

CO # uncomment if calculation of specific terms is required #
    PROC calculate term = ( INT m, []INT coef, h )INT:
         IF    m <= UPB h
         THEN ( h[ m ] + mdl ) MOD mdl
         ELIF INT k = UPB coef + 1;
              k = 0
         THEN 0
         ELSE [ 0 : k ]INT p coeffs;
              p coeffs[ 0     ] := ( mdl - 1 ) MOD mdl;
              p coeffs[ 1 : k ] := coef;

              INT degree k := k;
              [ 0 : degree k - 1 ]INT f, g;
              f[ 0 ] := 1;
              FOR i TO UPB f DO f[ i ] := 0 OD;
              FOR i FROM 0 TO UPB g DO g[ i ] := 0 OD;
              IF k = 1 THEN
                  g[ 0 ] := p coeffs[ 1 ]
              ELSE
                  g[ 1 ] := 1
              FI;

              INT power := m;
              [ 0 : 2 * degree k - 1 ]INT tmp;
              INT term := 0;

              WHILE power > 0 DO
                 IF ODD power THEN
                    FOR i FROM 0 TO UPB tmp DO tmp[ i ] := 0 OD;
                    FOR i FROM 0 TO degree k - 1 DO
                        IF f[ i ] /= 0 THEN
                            FOR j FROM 0 TO UPB f DO
                                tmp[ i + j ] +:= ( f[ i ] * g[ j ] ) MODAB mdl
                            OD
                        FI
                    OD;
                    FOR i FROM UPB tmp BY - 1 TO UPB f + 1 DO
                        IF tmp[ i ] /= 0 THEN
                            term     := tmp[ i ];
                            tmp[ i ] := 0;
                            FOR j FROM 0 TO k DO
                                INT idx = i - j;
                                IF idx >= 0 THEN
                                    tmp[ idx ] +:= ( term * p coeffs[ j ] ) MODAB mdl
                                FI
                            OD
                        FI
                    OD;
                    f := tmp[ 0 : UPB f AT 0 ]
                 FI;
                 FOR i FROM 0 TO UPB tmp DO tmp[ i ] := 0 OD;
                 FOR i FROM 0 TO UPB g DO
                     IF g[ i ] /= 0 THEN
                         FOR j FROM 0 TO UPB g DO
                             tmp[ i + j ] +:= ( g[ i ] * g[ j ] ) MODAB mdl
                         OD
                     FI
                 OD;
                 FOR i FROM UPB tmp BY -1 TO degree k DO
                     IF tmp[ i ] /= 0 THEN
                         term := tmp[ i ];
                         tmp[ i ] := 0;
                         FOR j FROM 0 TO k DO
                             INT idx = i - j;
                             IF idx >= 0 THEN
                                 tmp[ idx ] +:= ( term * p coeffs[ j ] ) MODAB mdl
                             FI
                         OD
                     FI
                 OD;
                 g := tmp[ 0 : UPB g AT 0 ];

                 power OVERAB 2
              OD;

              INT final ans := 0;
              FOR i FROM 0 TO degree k - 1 DO
                  IF i + 1 <= UPB h THEN
                      final ans +:= ( h[ i + 1 ] * f[ i ] ) MODAB mdl
                  FI
              OD;

              ( final ans + mdl ) MOD mdl
         FI # calculate term # ;
CO

    PROC solve = VOID:
         BEGIN

            []INT h input = []INT( 0, 0, 1, 1, 0, 1, 0 )[ AT 0 ];
            INT n = UPB h input + 1;
            [ 0 : n ]INT h;

            h[ 0 ] := 0; FOR i FROM LWB h TO UPB h - 1 DO h[ i + 1 ] := h input[ i ] OD;

            []INT ans coef = berlekamp massey( h );

            print( ( "Coefficients:" ) );
            FOR i FROM 0 TO UPB ans coef DO
                print( ( " ", whole( ( ans coef[ i ] + mdl ) MOD mdl, 0 ) ) )
            OD;
            print( ( newline ) )

            CO # Uncomment to calculate a specific term #
               ;
               INT m      = 10;
               INT result = calculate term( m, ans coef(), h() );
               print( ( "Term ", whole( m, 0 ) ) );
               print( ( ": ", whole( ( result + mdl ) MOD mdl, 0 ), newline ) )
            CO

         END # solve # ;

    solve

END
