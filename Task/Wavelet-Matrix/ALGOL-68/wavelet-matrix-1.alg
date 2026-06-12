# wavelet_matrix.incl.a68: Translated from the FreeBASIC sample              #

    # BitRank class for rank operations                                      #
    MODE BITRANK = STRUCT( REF[]BITS bitr              # Array to store bits #
                         , REF[]INT  count           # Array to store counts #
                         );

    # WaveletMatrix class                                                    #
    MODE WAVELETMATRIX = STRUCT( REF[]BITRANK b          # Array of BitRanks #
                               , REF[]INT     posic       # posicition array #
                               , INT          height  # Height of the matrix #
                               );	

    # Get bit at position bn from value, NB in Algol 68, the leftmost bit is #
    # bit 1, the rightmost is numbered bits width                            #
    PROC get bit at = ( INT value, bn )INT: ABS ( ( bits width - bn ) ELEM BIN value );

    # Count number of 1's in [0, i)                                          #
    PROC rank1 = ( REF BITRANK br, INT i )INT:
         BEGIN
            INT block index := i SHR  6;
            INT bitposic    := i AND 63;
            INT count       := 0;

            # Add count   from previous blocks                               #
            IF block index > 0 THEN count := ( count OF br )[ block index - 1 ] FI;

            # Count bits in current block                                    #
            FOR j FROM 0 TO bitposic - 1 DO
                IF ( ( bitr OF br )[ block index ] AND ( 1 SHL j ) ) /= 16r0 THEN count +:= 1 FI
            OD;
            count
         END # rank1 # ;

    # Count number of 0's in [0, i)                                          #
    PROC rank0 = ( REF BITRANK br, INT i )INT: i - rank1( br, i );

    # Initialize a BitRank structure                                         #
    PROC init bit rank = ( REF BITRANK br, INT size )VOID:
         BEGIN
            INT num blocks = ( size + 63 ) OVER 64;
            HEAP[ 0 : num blocks ]BITS new bits;
            HEAP[ 0 : num blocks ]INT  new counts;
            bitr OF br  := new bits;
            count OF br := new counts;
            FOR i FROM 0 TO num blocks DO
                ( bitr OF br  )[ i ] := 16r0;
                ( count OF br )[ i ] := 0
            OD
         END # init bit rank # ;

    # Initialize the WaveletMatrix with a vector                             #
    PROC create wavelet matrix = ( []INT vec, INT n, max val )WAVELETMATRIX:
         BEGIN
            # Calculate height based on maximum value                        #
            WAVELETMATRIX wm;
            height OF wm := 0;
            INT tmp      := max val;
            WHILE tmp > 0 DO
                height OF wm +:= 1;
                tmp OVERAB 2
            OD;
            # Initialize arrays                                              #
            HEAP[ 0 : height OF wm - 1 ]BITRANK new b;
            HEAP[ 0 : height OF wm - 1 ]INT     new posic;
            b OF wm     := new b;
            posic OF wm := new posic;
            # Create a copy of the input vector for manipulation             #
            [ 0 : n - 1 ]INT tmp vec := vec[ AT 0 ];

            FOR h FROM 0 TO height OF wm - 1 DO
                # Initialize BitRank                                         #
                init bit rank( ( b OF wm )[ h ], n );
                # Count zeros                                                #
                INT zeros := 0;
                FOR i FROM 0 TO n - 1 DO
                    IF get bit at( tmp vec[ i ], height OF wm - h - 1 ) = 0 THEN
                        zeros +:= 1
                    ELSE
                        # Set bit in BitRank                                 #
                        INT block idx = i SHR  6;
                        INT bitposic  = i AND 63;
                        ( bitr OF ( b OF wm )[ h ] )[ block idx ] ORAB ( 1 SHL bitposic )
                    FI
                OD;

                # Build count array                                          #
                INT running count := 0;
                FOR i FROM 0 TO UPB bitr OF ( b OF wm )[ h ] DO
                    INT  bit count := 0;
                    BITS bitr      := ( bitr OF ( b OF wm )[ h ] )[ i ];

                    # Count bits in this block                               #
                    WHILE bitr /= 16r0 DO
                        IF ( bitr AND 1 ) /= 16r0 THEN bit count +:= 1 FI;
                        bitr SHRAB 1
                    OD;

                    ( count OF ( b OF wm )[ h ] )[ i ] := running count;
                    running count +:= bit count
                OD;

                # Stable partition - separate 0's and 1's                    #
                [ 0 :     zeros - 1 ]INT zero values;
                [ 0 : n - zeros - 1 ]INT one values;
                INT zero idx := 0, one idx := 0;

                FOR i FROM 0 TO n - 1 DO
                    IF get bit at( tmp vec[ i ], height OF wm - h - 1 ) = 0 THEN
                        zero values[ zero idx ] := tmp vec[ i ];
                        zero idx               +:= 1
                    ELSE
                        one values[  one idx  ] := tmp vec[ i ];
                        one idx                +:= 1
                    FI
                OD;

                # Combine arrays back                                        #
                tmp vec[     0 : zeros - 1 ] := zero values[ 0 :     zeros - 1 ];
                tmp vec[ zeros :     n - 1 ] := one values[  0 : n - zeros - 1 ];

                ( posic OF wm )[ h ] := zeros
            OD;

            wm

         END # create wavelet matrix # ;

    # kth smallest element in [l, r)                                         #
    PROC quantile = ( REF WAVELETMATRIX wm, INT k in, l in, r in )INT:
         BEGIN
            INT k := k in, l := l in, r := r in;
            INT res := 0;
            FOR i FROM 0 TO height OF wm - 1 DO
                INT zeros = rank0( ( b OF wm )[ i ], r )
                          - rank0( ( b OF wm )[ i ], l )
                          ;
                IF zeros > k THEN                     # Go to left (0) child #
                    l := rank0( ( b OF wm )[ i ], l );
                    r := rank0( ( b OF wm )[ i ], r )
                ELSE                                #  Go to right (1) child #
                    l  := ( posic OF wm )[ i ] + rank1( ( b OF wm )[ i ], l );
                    r  := ( posic OF wm )[ i ] + rank1( ( b OF wm )[ i ], r );
                    k -:= zeros;
                    res ORAB ( 1 SHL ( height OF wm - i - 1 ) )
                FI
            OD;

            res
         END # quantile # ;


# end wavelet_matrix.incl.a68                                                #
