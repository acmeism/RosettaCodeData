BEGIN # Chaocipher, translated from the Kotlin with permutations as in Ada   #

    STRING lalphabet = "HXUCZVAMDSLKPEFJRIGTWOBNYQ";
    STRING ralphabet = "PTLNBQDEOYSFAVZKGJRIHWXUMC";

    PROC chaocipher = ( STRING text in, BOOL encrypt, show steps )STRING:
         BEGIN
            STRING left  := lalphabet[ AT 1 ];
            STRING right := ralphabet[ AT 1 ];
            STRING text   = text in  [ AT 1 ];
            OP LENGTH    = ( STRING s )INT: UPB s - LWB s + 1;
            [ 1 : LENGTH text ]CHAR e text;
            [ 1 : LENGTH left ]CHAR temp;

            FOR i TO UPB text DO
                IF show steps THEN print( ( left, "  ", right, newline ) ) FI;
                INT index;
                IF encrypt THEN
                    VOID( char in string( text[ i ], index, right ) );
                    e text[ i ] := IF index >= LWB left AND index <= UPB left
                                   THEN left[ index ]
                                   ELSE "?"
                                   FI
                ELSE
                    VOID( char in string( text[ i ], index, left  ) );
                    e text[ i ] := IF index >= LWB right AND index <= UPB right
                                   THEN right[ index ]
                                   ELSE "?"
                                   FI
                FI;
                IF index > 1 THEN
                    CHAR store;

                    # the permutations are performed using array slices      #
                    # rather than explicit loops                             #

                    # permute left                                           #

                    INT offset = 26 - index;
                    temp[ 1          : offset + 1 ] := left[ index : index + offset ];
                    temp[ offset + 2 : 26         ] := left[ 1     : index - 1      ];
                    store                           := temp[ 2 ];

                    temp[ 2 : 13 ] := temp[ 3 : 14 ];
                    temp[     14 ] := store;
                    left           := temp;

                    # permute right                                          #

                    temp[ 1 : offset + 1  ] := right[ index : index + offset ];
                    temp[ offset + 2 : 26 ] := right[ 1     : index - 1      ];
                    store                   := temp[ 1 ];

                    temp[ 1 : 25 ] := temp[ 2 : 26 ];
                    temp[     26 ] := store;
                    store          := temp[ 3 ];

                    temp[ 3 : 13 ] := temp[ 4 : 14 ];
                    temp[     14 ] := store;
                    right          := temp
                FI
            OD;
            e text
         END # chaocipher # ;

    STRING plaintext = "WELLDONEISBETTERTHANWELLSAID";
    print( ( "The original plaintext is : ", plaintext, newline ) );
    print( ( newline, "The left and right alphabets after each permutation" ) );
    print( ( " during encryption are :", newline, newline ) );
    STRING ciphertext = chaocipher( plaintext, TRUE,   TRUE  );
    print( ( newline, "The ciphertext is : ", ciphertext, newline ) );
    STRING plaintext2 = chaocipher( ciphertext, FALSE, FALSE );
    print( ( newline, "The recovered plaintext is : ", plaintext2 ) );
    print( ( " ", IF plaintext = plaintext2 THEN "" ELSE "NOT " FI, "as expected", newline ) )
END
