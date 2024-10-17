# Algol 68 doesn't have generic array searches but we can easily provide #
# type specific ones                                                     #

# mode to hold the city/population info #
MODE CITYINFO = STRUCT( STRING name, REAL population in millions );

# operator to find the first city with the specified criteria, expressed as a procedure #
# returns the index of the CITYINFO. We can also overload FIND so it can be applied to  #
# arrays of other types                                                                 #
# If there is no city matching the criteria, a value greater than the upper bound of    #
# the cities array is returned                                                          #
PRIO FIND = 1;
OP   FIND = ( REF[]CITYINFO cities, PROC( REF CITYINFO )BOOL criteria )INT:
     BEGIN
         INT  result := UPB cities + 1;
         BOOL found  := FALSE;
         FOR pos FROM LWB cities TO UPB cities WHILE NOT found DO
             IF criteria( cities[ pos ] )
             THEN
                 found  := TRUE;
                 result := pos
             FI
         OD;
         result
     END # FIND # ;

# convenience operator to determine whether a STRING starts with a particular character #
# returns TRUE if s starts with c, FALSE otherwise                                      #
PRIO STARTSWITH = 9;
OP   STARTSWITH = ( STRING s, CHAR c )BOOL:
     IF LWB s > UPB s THEN FALSE # empty string                                         #
     ELSE s[ LWB s ] = c
     FI # STARTSWITH # ;

BEGIN # tests                                                                           #

    # array of cities and populations #
    [ 1 : 10 ]CITYINFO cities := ( ( "Lagos",                21.0 )
                                 , ( "Cairo",                15.2 )
                                 , ( "Kinshasa-Brazzaville", 11.3 )
                                 , ( "Greater Johannesburg", 7.55 )
                                 , ( "Mogadishu",            5.85 )
                                 , ( "Khartoum-Omdurman",    4.98 )
                                 , ( "Dar Es Salaam",        4.7  )
                                 , ( "Alexandria",           4.58 )
                                 , ( "Abidjan",              4.4  )
                                 , ( "Casablanca",           3.98 )
                                 );
    INT city index := 0;

    # find the 0-based index of Dar Es Salaam #
    # ( if we remove the "[ @ 0 ]", it would find the 1-based index ) #
    # NB - this assumes there is one - would get a subscript bound error if there isn't #
    city index := cities[ @ 0 ] FIND ( ( REF CITYINFO city )BOOL: name OF city = "Dar Es Salaam" );
    print( ( "index of Dar Es Salaam (from 0): ", whole( city index, 0 ), newline ) );

    # find the first city with population under 5M #
    # NB - this assumes there is one - would get a subscript bound error if there isn't #
    city index := cities FIND ( ( REF CITYINFO city )BOOL: population in millions OF city < 5.0 );
    print( ( name OF cities[ city index ], " has a population under 5M", newline ) );

    # find the population of the first city whose name starts with "A" #
    # NB - this assumes there is one - would get a subscript bound error if there isn't #
    city index := cities FIND ( ( REF CITYINFO city )BOOL: name OF city STARTSWITH "A" );
    print( ( "The population of a city named ""A..."" is: " ) );
    print( ( fixed( population in millions OF cities[ city index ], 0, 2 ), newline ) )
END
