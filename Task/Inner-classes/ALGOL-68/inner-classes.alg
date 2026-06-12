BEGIN # demonstrate a possible method of simulating inner classes             #
    # declare OUTER and INNER "classes"                                       #
    MODE OUTER = STRUCT( INT                   omember    # integer member    #
                       , PROC REF REF OUTER    new0       # noarg constructer #
                       , REF  REF INNER        oinner     # INNER member      #
                       , PROC( REF OUTER )VOID print      # print method      #
                       );
    MODE INNER = STRUCT( REF REF OUTER         super      # parent OUTER      #
                       , CHAR                  cmember    # character member  #
                       , PROC( REF REF OUTER )REF REF INNER
                                               new0       # noarg constructor #
                          # but must be called withe the superclass "pointer" #
                       , PROC( REF INNER )VOID print      # print method      #
                       );
    # constructors                                                            #
    PROC new outer = REF REF OUTER:
         BEGIN
             HEAP OUTER     thisv := OUTER( 0
                                          , new outer
                                          , NIL
                                          , ( REF OUTER othis )VOID:
                                                print( ( "[", whole( omember OF othis, 0 ), "]" ) )
                                          );
             HEAP REF OUTER this  := thisv;
             oinner OF this       := new inner( this );
             this
         END # new outer # ;
    PROC new inner = ( REF REF OUTER super )REF REF INNER:
         BEGIN
             HEAP INNER     thisv := INNER( super
                                          , " "
                                          , new inner
                                          , ( REF INNER ithis )VOID:
                                                print( ( "<<", cmember OF ithis
                                                       , "><", whole( omember OF super OF ithis, 0 )
                                                       , ">>"
                                                       )
                                                     )
                                          );
             HEAP REF INNER this  := thisv;
             this
         END # new inner # ;

    REF OUTER o := new outer;                # create an instance of OUTER    #
    omember OF o := 27;                      # set o's integer member         #
    cmember OF oinner OF o := "-";  # set o's inner member's character member #
    ( print OF oinner OF o )( oinner OF o ); # call o's INNER members' print  #
    ( print OF o )( o );                     # call o's print                 #
    print( ( newline ) );
    omember OF o := 42;                      # update o's integer member      #
    cmember OF oinner OF o := "!";  # and its inner member's character member #
    ( print OF oinner OF o )( oinner OF o ); # call o's INNER members' print  #
    ( print OF o )( o );                     # call o's print                 #
    print( ( newline ) );
    REF INNER i := new inner( o );    # create a separate INNER instance also #
                                      #                         with parent o #
    cmember OF i := "$";       # update the separate INNER's character member #
    ( print OF i )( i );       # call the separate INNER's print method       #
    ( print OF o )( o );       # call o's print method again                  #
    print( ( newline ) );
    omember OF o := 91;                      # update o's integer member ...  #
    cmember OF oinner OF o := "?";  # and its INNER member's character member #
    ( print OF oinner OF o )( oinner OF o ); # call o's INNER members' print  #
    ( print OF o )( o );                     # call o's print method again    #
    print( ( newline ) );
    ( print OF i )( i );       # call the separate INNER's print method again #
    ( print OF o )( o );       # call o's print method again                  #
    print( ( newline ) )
END
