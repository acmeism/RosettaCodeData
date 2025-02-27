BEGIN # validate IBAN numbers                                                #

    # country code and expected bank account length for IBAN codes           #
    MODE IBANCOUNTRY = STRUCT( [ 1 : 2 ]CHAR code, INT length );

    []IBANCOUNTRY country info =
      ( ("AL",28), ("AD",24), ("AT",20), ("AZ",28), ("BE",16), ("BH",22), ("BA",20), ("BR",29)
      , ("BG",22), ("CR",21), ("HR",21), ("CY",28), ("CZ",24), ("DK",18), ("DO",28), ("EE",20)
      , ("FO",18), ("FI",18), ("FR",27), ("GE",22), ("DE",22), ("GI",23), ("GR",27), ("GL",18)
      , ("GT",28), ("HU",28), ("IS",26), ("IE",22), ("IL",23), ("IT",27), ("KZ",20), ("KW",30)
      , ("LV",21), ("LB",28), ("LI",21), ("LT",20), ("LU",20), ("MK",19), ("MT",31), ("MR",27)
      , ("MU",30), ("MC",27), ("MD",24), ("ME",22), ("NL",18), ("NO",15), ("PK",24), ("PS",29)
      , ("PL",28), ("PT",25), ("RO",24), ("SM",27), ("SA",24), ("RS",22), ("SK",24), ("SI",19)
      , ("ES",24), ("SE",24), ("CH",21), ("TN",24), ("TR",26), ("AE",23), ("GB",22), ("VG",24)
      );

    # returns "" if s could be a valid IBAN, an error message otherwise      #
    OP   POSSIBLEIBAN = ( STRING s )STRING:
         BEGIN
             BOOL   is valid := TRUE;
             STRING result   := "";
             # remove spaces and check we only have digits and spaces        #
             STRING iban := "";
             FOR s pos FROM LWB s TO UPB s WHILE is valid DO
                 CHAR c = s[ s pos ];
                 IF c /= " " THEN
                     IF   NOT ( is valid := ( c >= "A" AND c <= "Z" ) OR ( c >= "0" AND c <= "9" ) )
                     THEN result := "Invalid character: " + c
                     FI;
                     iban +:= c
                 FI
             OD;
             IF is valid THEN
                 # OK so far - check the length matches the country code     #
                 INT supplied length = ( UPB iban - LWB iban ) + 1;
                 is valid := FALSE;
                 IF   supplied length <= 4
                 THEN result := "Code is too short"
                 ELSE # enough characters for a country code and a check sum #
                      INT    expected length  := -1;
                      STRING supplied country  = iban[ LWB iban : LWB iban + 1 ];
                      FOR c pos FROM LWB country info TO UPB country info WHILE NOT is valid DO
                          IF is valid := code OF country info[ c pos ] = supplied country THEN
                              expected length := length OF country info[ c pos ]
                          FI
                      OD;
                      IF   NOT is valid
                      THEN result := "Not a known IBAN country: " + supplied country
                      ELIF NOT ( is valid := expected length = supplied length )
                      THEN result := "Expected code length: "  + whole( expected length, 0 )
                                   + " but actual length is: " + whole( supplied length, 0 )
                      ELSE # OK so far - check the checksum                   #
                          STRING rearranged iban = iban[ LWB iban + 4 : ] + iban[ LWB iban : LWB iban + 3 ];
                          LONG LONG INT numeric iban := 0;
                          FOR c pos FROM LWB rearranged iban TO UPB rearranged iban DO
                              CHAR c = rearranged iban[ c pos ];
                              IF c >= "0" AND c <= "9" THEN
                                  numeric iban *:= 10 +:= ( ABS c - ABS "0" )
                              ELSE
                                  numeric iban *:= 100 +:= ( ABS c - ABS "A" ) + 10
                              FI
                          OD;
                          IF   NOT ( is valid := numeric iban MOD 97 = 1 )
                          THEN result := "Incorrect checksum"
                          FI
                      FI
                 FI
             FI;
             IF is valid THEN "" ELIF result = "" THEN "Unknown error" ELSE result FI
         END # POSSIBLEIBAN # ;

    BEGIN # tests                                                            #
        []STRING valid codes   = ( "GB82 WEST 1234 5698 7654 32",       "GB82WEST12345698765432"
                                 , "GR16 0110 1250 0000 0001 2300 695", "GB29 NWBK 6016 1331 9268 19"
                                 , "SA03 8000 0000 6080 1016 7519",     "CH93 0076 2011 6238 5295 7"
                                 , "IL62 0108 0000 0009 9999 999"
                                 );
        []STRING invalid codes = ( "gb82 west 1234 5698 7654 32"        # invalid characters      #
                                 , "GB82 TEST 1234 5698 7654 32"        # invalid check digits    #
                                 , "IL62-0108-0000-0009-9999-999"       # invalid characters      #
                                 , "US12 3456 7890 0987 6543 210"       # invalid country code    #
                                 , "GR16 0110 1250 0000 0001 2300 695X" # invalid code length     #
                                 , ""                                   # code is too short       #
                                 , "G2"                                 # code is too short       #
                                 , "GB271"                              # invalid code length     #
                                 );
        FOR t pos FROM LWB valid codes TO UPB valid codes DO
            STRING code    = valid codes[ t pos ];
            STRING message = POSSIBLEIBAN code;
            IF   message = ""
            THEN print( ( "Possible IBAN: ", code, newline ) )
            ELSE print( ( "INVALID  IBAN: ", code, ": UNEXPECTED ERROR: ", message, newline ) )
            FI
        OD;
        FOR t pos FROM LWB invalid codes TO UPB invalid codes DO
            STRING code    = invalid codes[ t pos ];
            STRING message = POSSIBLEIBAN code;
            IF   message = ""
            THEN print( ( "POSSIBLE IBAN: ", code, " BUT EXPECTED AN ERROR MESSAGE", newline ) )
            ELSE print( ( "Invalid  IBAN: ", code, ": ", message, newline ) )
            FI
        OD
    END
END
