# move the character at text pos to the front of text                         #
# note text pos is based from 0                                               #
PROC move to front = ( STRING text, INT text pos )STRING:
    IF text pos < 1
    THEN
        # the character is already at the front (or not in the string)        #
        text
    ELSE
        # the character isn't already at the front - construct the new string #

        INT    char pos = LWB text + text pos;

        ( text[ char pos     : char pos     ]
        + text[              : char pos - 1 ]
        + text[ char pos + 1 :              ]
        )

    FI;


# encode the string "text", using "initial table" as the starting symbol table#
PROC encode = ( STRING text, STRING initial table )[]INT:
BEGIN

    [ 1 : ( UPB text - LWB text ) + 1 ]INT result;

    STRING symbol table := initial table;

    FOR text pos FROM LWB text TO UPB text
    DO
        INT    symbol pos := 0;

        result[ text pos ]
            := IF char in string( text[ text pos ], symbol pos, symbol table )
               THEN
                   # the character is in the symbol table at symbol pos       #
                   # (indexed from LWB text) - we store the positions         #
                   # indexed from 0                                           #
                   symbol pos - LWB text
               ELSE
                   # the character isn't in the symbol table                  #
                   -1
               FI;

        # modify the symbol table so the latest character is at the front     #
        symbol table := move to front( symbol table, result[ text pos ] )

    OD;

    result
END; # encode #



# decode "encoded", using "initial table" as the starting symbol table        #
PROC decode = ( []INT encoded, STRING initial table )STRING:
BEGIN

    STRING result       := "";
    STRING symbol table := initial table;

    FOR text pos FROM LWB encoded TO UPB encoded
    DO
        result
           +:= IF encoded[ text pos ] < 0
               THEN
                   # the encoded character wasn't in the string               #
                   "?"
               ELSE
                  # the character is in the symbol table                      #
                  symbol table[ encoded[ text pos ] + LWB symbol table ]
                FI;

        # modify the symbol table so the latest character is at the front     #
        symbol table := move to front( symbol table, encoded[ text pos ] )

    OD;

    result
END; # decode #



# routine to test the encode and decode routines                              #
PROC test encode and decode = ( STRING text )VOID:
BEGIN

    # initial value for the symbol table                                      #
    []CHAR initial table = "abcdefghijklmnopqrstuvwxyz";

    # procedure to format the encoded value                                   #
    PROC format encoded value = ( []INT values )STRING:
    BEGIN
        STRING result := "";
        FOR value pos FROM LWB values TO UPB values
        DO
            result +:= ( " " + whole( values[ value pos ], 0 ) )
        OD;

        result
    END; # format encoded value #

    []INT  encoded = encode( text,    initial table );
    STRING decoded = decode( encoded, initial table );

    print( ( ( text
             + " encodes to ["
             + format encoded value( encoded )
             + " ] which "
             + IF text = decoded
               THEN
                   "correctly"
               ELSE
                   "INCORRECTLY"
               FI
             + " decodes to """
             + decoded
             + """"
             )
           , newline
           )
         )

END; # test encode and decode #



main: (

     test encode and decode( "broood" )
  ;  test encode and decode( "bananaaa" )
  ;  test encode and decode( "hiphophiphop" )

# ;  test encode and decode( "abcdefghijklmnopqrstuvwxyz" ) #
# ;  test encode and decode( "zyxwvutsrqponmlkjihgfedcba" ) #

)
