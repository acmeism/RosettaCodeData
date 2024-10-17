BEGIN # pick a random element from an array of strings #

    OP PICKRANDOM = ( []STRING list )STRING:
    BEGIN

        INT number of elements = ( UPB list - LWB list ) + 1;
        INT random element     =
            ENTIER ( next random * ( number of elements ) );

        list[ LWB list + random element ]
    END; # PICKRANDOM #
    # can define additional operators for other types of array #


    BEGIN
        []STRING days = ( "Sunday",   "Monday", "Tuesday", "Wednesday"
                        , "Thursday", "Friday", "Saturday"
                        );

        print( ( PICKRANDOM days, newline ) )
    END
END
