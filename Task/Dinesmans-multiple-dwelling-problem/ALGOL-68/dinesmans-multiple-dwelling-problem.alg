# attempt to solve the dinesman Multiple Dwelling problem #

# SETUP #

# special floor values #
INT    top floor    = 4;
INT    bottom floor = 0;

# mode to specify the persons floor constraint #
MODE PERSON = STRUCT( STRING name, REF INT floor, PROC( INT )BOOL ok );

# yields TRUE if the floor of the specified person is OK, FALSE otherwise #
OP OK = ( PERSON p )BOOL: ( ok OF p )( floor OF p );

# yields TRUE if floor is adjacent to other persons floor, FALSE otherwise #
PROC adjacent = ( INT floor, other persons floor )BOOL: floor >= ( other persons floor - 1 ) AND floor <= ( other persons floor + 1 );

# displays the floor of an occupant #
PROC print floor = ( PERSON occupant )VOID: print( ( whole( floor OF occupant, -1 ), " ", name OF occupant, newline ) );

# PROBLEM STATEMENT #

# the inhabitants with their floor and constraints #
PERSON baker    = ( "Baker",    LOC INT := 0, ( INT floor )BOOL: floor /= top floor );
PERSON cooper   = ( "Cooper",   LOC INT := 0, ( INT floor )BOOL: floor /= bottom floor );
PERSON fletcher = ( "Fletcher", LOC INT := 0, ( INT floor )BOOL: floor /= top floor AND floor /= bottom floor
                                                                                    AND NOT adjacent( floor, floor OF cooper ) );
PERSON miller   = ( "Miller",   LOC INT := 0, ( INT floor )BOOL: floor > floor OF cooper );
PERSON smith    = ( "Smith",    LOC INT := 0, ( INT floor )BOOL: NOT adjacent( floor, floor OF fletcher ) );

# SOLUTION #

# "brute force" solution - we run through the possible 5^5 configurations          #
# we cold optimise this by e.g. restricting f to bottom floor + 1 TO top floor - 1 #
# at the cost of reducing the flexibility of the constraints                       #
# alternatively, we could add minimum and maximum allowed floors to the PERSON     #
# STRUCT and loop through these instead of bottom floor TO top floor               #

FOR b FROM bottom floor TO top floor DO
    floor OF baker := b;
    FOR c FROM bottom floor TO top floor DO
        IF b /= c THEN
            floor OF cooper := c;
            FOR f FROM bottom floor TO top floor DO
                IF b /= f AND c /= f THEN
                    floor OF fletcher := f;
                    FOR m FROM bottom floor TO top floor DO
                        IF b /= m AND c /= m AND f /= m THEN
                            floor OF miller   := m;
                            FOR s FROM bottom floor TO top floor DO
                                IF b /= s AND c /= s AND f /= s AND m /= s THEN
                                    floor OF smith    := s;
                                    IF OK baker AND OK cooper AND OK fletcher AND OK miller AND OK smith
                                    THEN
                                        # found a solution #
                                        print floor( baker    );
                                        print floor( cooper   );
                                        print floor( fletcher );
                                        print floor( miller   );
                                        print floor( smith    )
                                    FI
                                FI
                            OD
                        FI
                    OD
                FI
            OD
        FI
    OD
OD
