BEGIN # demonstrate a possible method of simulating class & instance methods  #
    # declare a "class"                                                       #
    MODE ANIMAL = STRUCT( STRING                 species
                        , PROC( REF ANIMAL )VOID print    # instance method   #
                        , PROC VOID              cm       # class method      #
                        );
    # constructor                                                             #
    PROC new animal = ( STRING species )REF REF ANIMAL:
         BEGIN
             HEAP ANIMAL     newv := ANIMAL( species
                                           , ( REF ANIMAL this )VOID:
                                               print( ( "[animal instance[", species OF this, "]]" ) )
                                           , VOID: print( ( "[animal class method called]" ) )
                                           );
             HEAP REF ANIMAL newa := newv;
             newa
         END # new animal # ;

    REF ANIMAL a
           := new animal( "PANTHERA TIGRIS" ); # create an instance of ANIMAL #
    cm OF a;                                   # call the class method        #
    ( print OF a )( a )                        # call the instance method     #
END
