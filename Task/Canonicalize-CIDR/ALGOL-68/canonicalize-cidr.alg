BEGIN # show IPv4 addresses in CIDR notation in canonical form #
    # mode to hold an IPv4 address in CIDR notation #
    MODE CIDR = STRUCT( BITS   address
                      , INT    network bits
                      , BOOL   valid
                      , STRING error
                      );
    # returns a CIDR parsed from address #
    OP TOCIDR = ( STRING address text )CIDR:
         BEGIN
            STRING addr         = "." + address text + "$";
            STRING error       := "";
            BITS   address     := 16r0;
            INT    bits count  := 0;
            INT    dot count   := 0;
            INT    slash count := 0;
            BOOL   valid       := TRUE;
            INT    s pos       := LWB addr;
            INT    s max        = UPB addr;
            WHILE s pos < s max AND valid DO
                IF addr[ s pos ] = "." THEN
                    # must have an octet next #
                    dot count +:= 1;
                    INT octet  := 0;
                    INT digits := 0;
                    WHILE CHAR c = addr[ s pos +:= 1 ];
                          c >= "0" AND c <= "9"
                    DO
                        octet  *:= 10 +:= ( ABS c - ABS "0" );
                        digits +:= 1
                    OD;
                    address := ( address SHL 8 ) OR BIN ( octet MOD 256 );
                    valid := valid AND digits > 0 AND digits < 4 AND octet < 256;
                    IF NOT valid THEN error := "too many digits/octet to large" FI
                ELIF addr[ s pos ] = "/" THEN
                    # must have the network mask length next #
                    slash count +:= 1;
                    WHILE CHAR c = addr[ s pos +:= 1 ];
                          c >= "0" AND c <= "9"
                    DO
                        bits count  *:= 10 +:= ( ABS c - ABS "0" )
                    OD;
                    # should be "$" ( end of string marker ) next #
                    valid := valid AND addr[ s pos ] = "$";
                    IF NOT valid THEN error := "bit length not followed by end-of-string" FI
                ELIF addr[ s pos ] = "$" THEN
                    # end of address marker - must be the final character #
                    valid := valid AND s pos = s max;
                    IF NOT valid THEN error := "Invalid character: ""$""" FI
                ELSE
                    # invalid character #
                    valid := FALSE;
                    error := "Invalid character: """ + addr[ s pos ] + """"
                FI
            OD;
            IF valid THEN
                # address is OK so far - check it had four octets and one mask length #
                valid := dot count   =  4 # note a leading "." was added for parsing #
                     AND slash count =  1
                     AND bits count  >  0
                     AND bits count  < 33;
                IF NOT valid THEN error := "too many dots, slashes or bits" FI
            FI;
            CIDR( address, bits count, valid, error )
         END # TOCIDR # ;
    # returns address in canonical form #
    OP CANONICALISE = ( CIDR address )CIDR:
         IF NOT valid OF address THEN
            # invalid address #
            address
         ELSE
            # valid address - retain the top most bits #
            CIDR( address OF address AND (   16rffffffff
                                         SHL ( 32 - network bits OF address )
                                         )
                , network bits OF address
                , TRUE
                , ""
                )
         FI # CANONICALISE # ;
    # returns a readable form of address #
    OP TOSTRING = ( CIDR address )STRING:
         BEGIN
             [ 1 : 4 ]INT octet;
             BITS addr := address OF address;
             FOR o pos FROM UPB octet BY -1 TO LWB octet DO
                 octet[ o pos ] := ABS ( addr AND 16rff );
                 addr           := addr SHR 8
             OD;
             STRING result := whole( octet[ LWB octet ], 0 );
             FOR o pos FROM 1 + LWB octet TO UPB octet DO
                 result +:= "." + whole( octet[ o pos ], 0 )
             OD;
             result + "/" + whole( network bits OF address, 0 )
         END # TOSTRING # ;
    # task examples :          input                 expected result    #
    [,]STRING test cases = ( ( "87.70.141.1/22",     "87.70.140.0/22"   )
                           , ( "36.18.154.103/12",   "36.16.0.0/12"     )
                           , ( "62.62.197.11/29",    "62.62.197.8/29"   )
                           , ( "67.137.119.181/4",   "64.0.0.0/4"       )
                           , ( "161.214.74.21/24",   "161.214.74.0/24"  )
                           , ( "184.232.176.184/18", "184.232.128.0/18" )
                           );
    FOR t pos FROM 1 LWB test cases TO 1 UPB test cases DO
        STRING addr  = test cases[ t pos, 1 ];
        CIDR   canon = CANONICALISE TOCIDR addr;
        IF NOT valid OF canon THEN
            print( ( "Invalid address: """, addr, """: ", error OF canon, newline ) )
        ELSE
            STRING actual   = TOSTRING canon;
            STRING expected = test cases[ t pos, 2 ];
            print( ( addr
                   , " -> "
                   , actual
                   , IF expected = actual THEN "" ELSE " ** EXPECTED: """ + expected + """" FI
                   , newline
                   )
                 )
        FI
    OD
END
