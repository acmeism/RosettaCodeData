BEGIN
    # Algol 68 doesn't have classes and inheritence as such, however structures #
    # can contain procedures and different instances of a structure can have    #
    # different versons of the procedure                                        #
    # this allows us to simulate inheritence by creating structure instances    #
    # with different procedures                                                 #

    # the following declares a type (MODE) HORSE with two constructors, one for #
    # a standard horse and one for a zebra (the "derived class").               #
    # The standard horse has its print procedure set to thw print horse         #
    # procedure (the "base class" method). zebras get the print zebra procedure #
    # (the "derived class" method). A convenience operator (PRINT) is defined   #
    # to simplify calling the horse/zebra print method of its horse parameter   #
    # = this PRINT operator is independent of which actual print method the     #
    # horse has - it just saved typeing "( print OF h )( h )" everywhere we     #
    # need to call the print method (euivalent to h.print(h) in e.g. C, Java,   #
    # etc.)                                                                     #

    # "class" #
    MODE HORSE = STRUCT( STRING name, PROC(HORSE)VOID print );
    # constructors #
    PROC new horse   = ( STRING name )HORSE: ( name, print horse );
    PROC new zebra   = ( STRING name )HORSE: ( name, print zebra );
    # print methods: one for a standard horse and one for a zebra #
    PROC print horse = ( HORSE  h    )VOID: print( ( "horse: ", name OF h ) );
    PROC print zebra = ( HORSE  h    )VOID: print( ( "zebra: ", name OF h ) );
    # print operator #
    OP   PRINT       = ( HORSE  h    )VOID: ( print OF h )( h );

    # declare and construct some horses and zebras #
    HORSE h1 := new horse( "silver blaze" );
    HORSE z1 := new zebra( "stripy" );
    HORSE z2 := new zebra( "second zebra" );

    # show their values #
    PRINT h1; print( ( newline ) );
    PRINT z1; print( ( newline ) );
    PRINT z2; print( ( newline ) );
    print( ( "----", newline ) );

    # change the second zebra to be a copy of the first zebra #
    z2 := z1;
    PRINT z1; print( ( newline ) );
    PRINT z2; print( ( newline ) );
    print( ( "----", newline ) );

    # change the name of the first zebra leaving z2 unchanged #
    name OF z1 := "ed";
    PRINT z1; print( ( newline ) );
    PRINT z2; print( ( newline ) )
END
