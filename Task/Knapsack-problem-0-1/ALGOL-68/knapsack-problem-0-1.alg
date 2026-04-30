BEGIN # Knapsack problem: 0-1                                                #

    PR read "bits.incl.a68" PR   # include bit manipulation utilities   #

    # returns the next highest integer with the same number of set bits #
    PROC gospers hack = ( INT x )INT:             # using Gosper's Hack #
         BEGIN
            INT c = x AND - x;
            INT r = x + c;
            ENTIER ( ENTIER ( ( r XOR x ) / 4 ) / c ) OR r
         END # gospers hack # ;

    # knapsack items                                                         #
    MODE ITEM  = STRUCT( STRING name, INT weight, value );
    []ITEM possible items
         = ( ( "map",                      9, 150 ), ( "compass",             13,  35 )
           , ( "water",                  153, 200 ), ( "sandwich",            50, 160 )
           , ( "glucose",                 15,  60 ), ( "tin",                 68,  45 )
           , ( "banana",                  27,  60 ), ( "apple",               39,  40 )
           , ( "cheese",                  23,  30 ), ( "beer",                52,  10 )
           , ( "suntan cream",            11,  70 ), ( "camera",              32,  30 )
           , ( "t-shirt",                 24,  15 ), ( "trousers",            48,  10 )
           , ( "umbrella",                73,  40 ), ( "waterproof trousers", 42,  70 )
           , ( "waterproof overclothes",  43,  75 ), ( "note-case",           22,  80 )
           , ( "sunglasses",               7,  20 ), ( "towel",               18,  12 )
           , ( "socks",                    4,  50 ), ( "book",                30,  10 )
           );

    [ 1 : UPB possible items ]ITEM sack items := possible items;

    PRIO SWAP  = 1;
    OP   SWAP  = ( REF ITEM a, b )VOID: BEGIN ITEM t = a; a := b; b := t END;

    # sort the items into descending value order                        #
    FOR p TO UPB sack items - 1 DO
        FOR q FROM p + 1 TO UPB sack items DO
            IF value OF sack items[ q ] > value OF sack items[ p ] THEN sack items[ p ] SWAP sack items[ q ] FI
        OD
    OD;
    # calculate the maximum value of each number of items,              #
    # if they could all be carried                                      #
    [ 1 : UPB possible items ]INT possible value;
    INT curr value := 0;
    FOR p TO UPB sack items - 1 DO
        curr value +:= value OF sack items[ p ];
        possible value[ p ] := curr value
    OD;

    # sort the items into descending weight order                       #
    FOR p TO UPB sack items - 1 DO
        FOR q FROM p + 1 TO UPB sack items DO
            IF weight OF sack items[ q ] > weight OF sack items[ p ] THEN sack items[ p ] SWAP sack items[ q ] FI
        OD
    OD;

    # find the minimum and maximum number of items we can carry         #
    # NB - assumes that each item weighs less than the maximum that can #
    # be carried                                                        #
    INT max weight   = 400;
    INT min carry   :=   0;
    INT curr weight :=   weight OF sack items[ 1 ];
    FOR s pos FROM 2 TO UPB sack items WHILE curr weight <= max weight DO
        min carry   +:= 1;
        curr weight +:= weight OF sack items[ s pos ]
    OD;
    INT max carry   :=   0;
    curr weight     := weight OF sack items[ UPB sack items ];
    FOR s pos FROM UPB sack items - 1 BY -1 TO 1 WHILE curr weight <= max weight DO
        max carry   +:= 1;
        curr weight +:= weight OF sack items[ s pos ]
    OD;

    INT best items  := 0;
    INT best value  := 0;
    INT best weight := 0;

    # for each possible number of items, find the best value for weight #
    # with that many items                                              #
    # we use a bit mask to select the permutations, the maximum         #
    # permutation is 2^length - 1                                       #
    INT max perm = 2 ^ UPB sack items - 1;

    FOR item count FROM max carry BY -1 TO min carry WHILE best value < possible value[ item count ] DO
        # the lowest permutation is 2^number of items - 1               #
        INT perm   := 2 ^ item count - 1;

        WHILE perm <= max perm DO
            INT v      := perm;
            INT weight := 0;
            INT value  := 0;
            INT used   := 0;
            FOR sack pos TO UPB sack items WHILE v > 0 AND weight <= max weight DO
                IF ODD v THEN
                    weight +:= weight OF sack items[ sack pos ];
                    value  +:=  value OF sack items[ sack pos ];
                    used   +:= 1
                FI;
                v OVERAB 2
            OD;
            IF weight <= max weight AND used = item count THEN
                IF value > best value THEN
                    best items  := perm;
                    best value  := value;
                    best weight := weight
                FI
            FI;
            perm := gospers hack( perm )
        OD
    OD;

    print( ( "At least ", whole( min carry, 0 ), " and at most ", whole( max carry, 0 ) ) );
    print( ( " items could be carried", newline ) );
    print( ( "Bast value: ", whole( best value, 0 ), " with weight: ", whole( best weight, 0 ), " is:", newline ) );
    INT items := best items;
    INT count := 0;
    FOR sack pos TO UPB sack items WHILE items > 0 DO
        IF ODD items THEN
            count +:= 1;
            print( ( "    ", name OF sack items[ sack pos ], newline ) )
        FI;
        items OVERAB 2
    OD;
    print( ( "total: ", whole( count, 0 ), " items.", newline ) )

END
