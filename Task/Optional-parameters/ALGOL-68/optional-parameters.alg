# as the options have distinct types (INT, BOOL and PROC( STRING, STRING )INT) the       #
# easiest way to support these optional parameters in Algol 68 would be to have an array #
# with elements of these types                                                           #
# See the Named Arguments sample for cases where the option types are not distinct       #

# default comparison function #
PROC default compare = ( STRING a, b )INT: IF a < b THEN -1 ELIF a = b THEN 0 ELSE 1 FI;

# sorting procedure #
PROC configurable sort = ( [,]STRING data, []UNION( INT, BOOL, PROC( STRING, STRING )INT ) options )VOID:
BEGIN
    # set initial values for the options #
    INT    sort column                   := 2 LWB data;
    BOOL   reverse sort                  := FALSE;
    PROC( STRING, STRING )INT comparator := default compare;
    # overide from the supplied options #
    FOR opt pos FROM LWB options TO UPB options DO
        CASE options[ opt pos ]
          IN ( PROC( STRING, STRING )INT p ): comparator   := p
           , ( INT c ):                       sort column  := c
           , ( BOOL r ):                      reverse sort := r
        ESAC
    OD
    # do the sort .... #
END # configurable sort # ;

BEGIN # example calls #
    [ 1 : 2, 1 : 3 ]STRING data := ( ( "a", "bb", "cde" ), ( "x", "abcdef", "Q" ) );

    # sort data, default comparison, first column, reverse order #
    configurable sort( data, ( TRUE ) );
    # sort data, second column, ignore first chaacter when sorting, normal order #
    configurable sort( data, ( 2
                             , ( STRING a, STRING b )INT: default compare( a[ LWB a + 1 : ]
                                                                         , b[ LWB b + 1 : ]
                                                                         )
                             )
                     );
    # default sort #
    configurable sort( data, () )
END
