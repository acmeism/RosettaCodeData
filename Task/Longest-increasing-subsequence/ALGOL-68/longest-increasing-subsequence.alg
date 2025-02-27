BEGIN # find the longest increasing subsequence of a list                    #
      #    - translated from the Kotlin sample                               #

    PR read "rows.incl.a68" PR      # include array utilities including SHOW #

    PROC longest increasing subsequence = ( []INT x in )[]INT:
         IF   []INT x = x in[ AT 0 ]; # normalise array bounds to 0 : n - 1  #
              INT   n = ( UPB x - LWB x ) + 1;
              n = 0
         THEN []INT()                                           # empty list #
         ELIF n = 1
         THEN x                                                # one element #
         ELSE [ 0 : n - 1 ]INT p;
              [ 0 : n     ]INT m; FOR i FROM LWB m TO UPB m DO m[ i ] := 0 OD;
              INT len := 0;
              FOR i FROM 0 TO n - 1 DO
                  INT lo := 1;
                  INT hi := len;
                  WHILE lo <= hi DO
                      REAL midr = ( lo + hi ) / 2;
                      INT  midi = ENTIER midr;
                      INT  mid  = IF midi = midr THEN midi ELSE midi + 1 FI;
                      IF x[ m[ mid ] ] < x[ i ] THEN lo := mid + 1 ELSE hi := mid - 1 FI
                  OD;
                  INT new len = lo;
                  p[ i       ] := m[ new len - 1 ];
                  m[ new len ] := i;
                  IF new len > len THEN len := new len FI
              OD;
              [ 0 : len - 1 ]INT s;
              INT k := m[ len ];
              FOR i FROM len - 1 BY -1 TO 0 DO
                  s[ i ] := x[ k ];
                  k      := p[ k ]
              OD;
              s
         FI # longest increasing subsequence # ;

    PROC show longest increasing subsequence = ( []INT x )VOID:
         BEGIN
            print( ( "[" ) ); SHOW longest increasing subsequence( x ); print( ( " ]", newline ) )
         END # show longest increasing subsequence # ;

    show longest increasing subsequence( ( 3, 2, 6, 4, 5, 1 ) );
    show longest increasing subsequence( ( 0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15 ) )

END
