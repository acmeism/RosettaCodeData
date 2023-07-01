BEGIN # find the missing permutation in a list using the XOR method of the Raku sample #
    # the list to find the missing permutation of #
    []STRING list = ( "ABCD", "CABD", "ACDB", "DACB", "BCDA"
                    , "ACBD", "ADCB", "CDAB", "DABC", "BCAD"
                    , "CADB", "CDBA", "CBAD", "ABDC", "ADBC"
                    , "BDCA", "DCBA", "BACD", "BADC", "BDAC"
                    , "CBDA", "DBCA", "DCAB"
                    );
    # sets b to b XOR v and returns b #
    PRIO XORAB = 1;
    OP   XORAB = ( REF BITS b, BITS v )REF BITS: b := b XOR v;

    # loop through each character of each element of the list #
    FOR c pos FROM LWB list[ LWB list ] TO UPB list[ LWB list ] DO
        # loop through each element of the list #
        BITS m := 16r0;
        FOR l pos FROM LWB list TO UPB list DO
            m XORAB BIN ABS list[ l pos ][ c pos ]
        OD;
        print( ( REPR ABS m ) )
    OD
END
