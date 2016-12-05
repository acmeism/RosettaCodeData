# associative array handling using hashing                                   #

# the modes allowed as associative array element values - change to suit     #
MODE AAVALUE = STRING;
# the modes allowed as associative array element keys - change to suit       #
MODE AAKEY   = STRING;
# nil element value                                                          #
REF AAVALUE nil value = NIL;

# an element of an associative array                                         #
MODE AAELEMENT = STRUCT( AAKEY key, REF AAVALUE value );
# a list of associative array elements - the element values with a           #
# particular hash value are stored in an AAELEMENTLIST                       #
MODE AAELEMENTLIST = STRUCT( AAELEMENT element, REF AAELEMENTLIST next );
# nil element list reference                                                 #
REF AAELEMENTLIST nil element list = NIL;
# nil element reference                                                      #
REF AAELEMENT     nil element      = NIL;

# the hash modulus for the associative arrays                                #
INT hash modulus = 256;

# generates a hash value from an AAKEY - change to suit                      #
OP HASH = ( STRING key )INT:
BEGIN
    INT result := ABS ( UPB key - LWB key ) MOD hash modulus;
    FOR char pos FROM LWB key TO UPB key DO
        result PLUSAB ( ABS key[ char pos ] - ABS " " );
        result MODAB  hash modulus
    OD;
    result
END; # HASH #

# a mode representing an associative array                                    #
MODE AARRAY = STRUCT( [ 0 : hash modulus - 1 ]REF AAELEMENTLIST elements
                    , INT                                       curr hash
                    , REF AAELEMENTLIST                         curr position
                    );

# initialises an associative array so all the hash chains are empty           #
OP   INIT = ( REF AARRAY array )REF AARRAY:
     BEGIN
         FOR hash value FROM 0 TO hash modulus - 1 DO ( elements OF array )[ hash value ] := nil element list OD;
         array
     END; # INIT #

# gets a reference to the value corresponding to a particular key in an      #
# associative array - the element is created if it doesn't exist             #
PRIO // = 1;
OP   // = ( REF AARRAY array, AAKEY key )REF AAVALUE:
BEGIN
    REF AAVALUE result;
    INT         hash value = HASH key;
    # get the hash chain for the key #
    REF AAELEMENTLIST element := ( elements OF array )[ hash value ];
    # find the element in the list, if it is there #
    BOOL found element := FALSE;
    WHILE ( element ISNT nil element list )
      AND NOT found element
    DO
        found element := ( key OF element OF element = key );
        IF found element
        THEN
            result  := value OF element OF element
        ELSE
            element := next OF element
        FI
    OD;
    IF NOT found element
    THEN
        # the element is not in the list #
        # - add it to the front of the hash chain #
        ( elements OF array )[ hash value ]
                            := HEAP AAELEMENTLIST
                            := ( HEAP AAELEMENT := ( key
                                                   , HEAP AAVALUE := ""
                                                   )
                               , ( elements OF array )[ hash value ]
                               );
        result := value OF element OF ( elements OF array )[ hash value ]
    FI;
    result
END; # // #

# returns TRUE if array contains key, FALSE otherwise                        #
PRIO CONTAINSKEY = 1;
OP   CONTAINSKEY = ( REF AARRAY array, AAKEY key )BOOL:
BEGIN
    # get the hash chain for the key #
    REF AAELEMENTLIST element := ( elements OF array )[ HASH key ];
    # find the element in the list, if it is there #
    BOOL found element := FALSE;
    WHILE ( element ISNT nil element list )
      AND NOT found element
    DO
        found element := ( key OF element OF element = key );
        IF NOT found element
        THEN
            element := next OF element
        FI
    OD;
    found element
END; # CONTAINSKEY #

# gets the first element (key, value) from the array                         #
OP FIRST = ( REF AARRAY array )REF AAELEMENT:
BEGIN
    curr hash     OF array := LWB ( elements OF array ) - 1;
    curr position OF array := nil element list;
    NEXT array
END; # FIRST #

# gets the next element (key, value) from the array                          #
OP NEXT  = ( REF AARRAY array )REF AAELEMENT:
BEGIN
    WHILE ( curr position OF array IS nil element list )
      AND   curr hash     OF array < UPB ( elements OF array )
    DO
        # reached the end of the current element list - try the next         #
        curr hash     OF array +:= 1;
        curr position OF array  := ( elements OF array )[ curr hash OF array ]
    OD;
    IF   curr hash OF array > UPB ( elements OF array )
    THEN
        # no more elements #
        nil element
    ELIF curr position OF array IS nil element list
    THEN
        # reached the end of the table #
        nil element
    ELSE
        # have another element #
        REF AAELEMENTLIST found element = curr position OF array;
        curr position OF array := next OF curr position OF array;
        element OF found element
    FI
END; # NEXT #

# test the associative array #
BEGIN
    # create an array and add some values  #
    REF AARRAY a1 := INIT LOC AARRAY;
    a1 // "k1" := "k1 value";
    a1 // "z2" := "z2 value";
    a1 // "k1" := "new k1 value";
    a1 // "k2" := "k2 value";
    a1 // "2j" := "2j value";
    # iterate over the values #
    REF AAELEMENT e := FIRST a1;
    WHILE e ISNT nil element
    DO
        print( ( "  (" + key OF e + ")[" + value OF e + "]", newline ) );
        e := NEXT a1
    OD
END
