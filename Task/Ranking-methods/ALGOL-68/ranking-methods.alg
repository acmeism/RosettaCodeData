BEGIN # rank some scores by various methods                                   #
    # MODE to hold the scores                                                 #
    MODE RESULT = STRUCT( INT score, STRING name );
    # returns the standard ranking of s                                       #
    PROC standard ranking = ( []RESULT s )[]INT:
         IF LWB s > UPB s THEN []INT() # no scores                            #
         ELSE                          # have some scores                     #
            [ LWB s : UPB s ]INT ranked;
            INT position := 1;
            ranked[ LWB s ] := position;
            FOR i FROM LWB s + 1 TO UPB s DO
                ranked[ i ] := IF score OF s[ i ] = score OF s[ i - 1 ] THEN
                                   # same score as the previous               #
                                   position
                               ELSE
                                   # different score, increase the position   #
                                   position := i
                               FI
            OD;
            ranked
         FI # standard ranking # ;
    # returns the modified ranking of s                                       #
    PROC modified ranking = ( []RESULT s )[]INT:
         IF LWB s > UPB s THEN []INT() # no scores                            #
         ELSE                          # have some scores                     #
            [ LWB s : UPB s ]INT ranked;
            INT position := ( UPB s + 1 ) - LWB s;
            ranked[ UPB s ] := position;
            FOR i FROM UPB s - 1 BY -1 TO LWB s DO
                ranked[ i ] := IF score OF s[ i ] = score OF s[ i + 1 ] THEN
                                   # same score as the previous               #
                                   position
                               ELSE
                                   # different score, decrease the position   #
                                   position := i
                               FI
            OD;
            ranked
         FI # modified ranking # ;
    # returns the debse ranking of s                                          #
    PROC dense ranking = ( []RESULT s )[]INT:
         IF LWB s > UPB s THEN []INT() # no scores                            #
         ELSE                          # have some scores                     #
            [ LWB s : UPB s ]INT ranked;
            INT position := 1;
            ranked[ LWB s ] := position;
            FOR i FROM LWB s + 1 TO UPB s DO
                ranked[ i ] := IF score OF s[ i ] = score OF s[ i - 1 ] THEN
                                   # same score as the previous               #
                                   position
                               ELSE
                                   # different score, increase the position   #
                                   position +:= 1
                               FI
            OD;
            ranked
         FI # dense ranking # ;
    # returns the ordinal ranking of s                                        #
    PROC ordinal ranking = ( []RESULT s )[]INT:
         IF LWB s > UPB s THEN []INT() # no scores                            #
         ELSE                          # have some scores                     #
            [ LWB s : UPB s ]INT ranked;
            INT position := 0;
            FOR i FROM LWB s TO UPB s DO
                ranked[ i ] := position +:= 1
            OD;
            ranked
         FI # ordinal ranking # ;
    # regturns the fractional ranking of s                                    #
    PROC fractional ranking = ( []RESULT s )[]REAL:
         IF LWB s > UPB s THEN []REAL() # no scores                           #
         ELSE                          # have some scores                     #
            [ LWB s : UPB s ]REAL ranked;
            FOR i FROM LWB s TO UPB s DO
                ranked[ i ]
                    := IF IF   i = LWB s
                          THEN FALSE
                          ELSE score OF s[ i ] = score OF s[ i - 1 ]
                          FI
                       THEN
                           # same score as the previous                       #
                           ranked[ i - 1 ]
                       ELSE
                           # first score or different score to the previous   #
                           INT same count := 1;
                           INT sum        := i;
                           FOR j FROM i + 1 TO UPB s
                           WHILE score OF s[ i ] = score OF s[ j ]
                           DO
                               same count +:= 1;
                               sum        +:= j
                           OD;
                           sum / same count
                       FI
            OD;
            ranked
         FI # fractional ranking # ;
    # shows the integer ranking of some scores                                #
    PROC show integral ranking = ( []RESULT s, []INT ranking, STRING title )VOID:
         BEGIN
            print( ( title, " competition ranking:", newline ) );
            FOR i FROM LWB s TO UPB s DO
                print( ( whole( ranking[ i ], -3 )
                       , ": "
                       , whole( score OF s[ i ], -3 )
                       , " "
                       , name OF s[ i ]
                       , newline
                       )
                     )
            OD;
            print( ( newline ) )
         END # show integral ranking # ;
    # shows the real ranking of some scores                                   #
    PROC show real ranking = ( []RESULT s, []REAL ranking, STRING title )VOID:
         BEGIN
            print( ( title, " competition ranking:", newline ) );
            FOR i FROM LWB s TO UPB s DO
                print( ( IF INT integer rank = ENTIER ranking[ i ];
                            integer rank = ranking[ i ]
                         THEN
                             whole( integer rank, -3 ) + "   "
                         ELSE
                             fixed( ranking[ i ], -6, 2 )
                         FI
                       , ": "
                       , whole( score OF s[ i ], -3 ), " "
                       , name OF s[ i ]
                       , newline
                       )
                     )
            OD;
            print( ( newline ) )
         END # show real ranking # ;

    # scores to rank - task test cases                                        #
    []RESULT scores = ( ( 44, "Solomon" )
                      , ( 42, "Jason"   )
                      , ( 42, "Errol"   )
                      , ( 41, "Garry"   )
                      , ( 41, "Bernard" )
                      , ( 41, "Barry"   )
                      , ( 39, "Stephen" )
                      );
    show integral ranking( scores,   standard ranking( scores ), "standard"   );
    show integral ranking( scores,   modified ranking( scores ), "modified"   );
    show integral ranking( scores,      dense ranking( scores ), "dense"      );
    show integral ranking( scores,    ordinal ranking( scores ), "ordinal"    );
    show real ranking(     scores, fractional ranking( scores ), "fractional" )

END
