BEGIN # find some anaprimes: groups of primes that have the same digits and  #
      #                      so are anagrams                                 #
    INT max prime = 10 000 000;            # maximum number we will consider #
    [ 0 : max prime ]BOOL prime;             # sieve the primes to max prime #
    prime[ 0 ] := prime[ 1 ] := FALSE;
    prime[ 2 ] := TRUE;
    FOR i FROM 3 BY 2 TO UPB prime DO prime[ i ] := TRUE  OD;
    FOR i FROM 4 BY 2 TO UPB prime DO prime[ i ] := FALSE OD;
    FOR i FROM 3 BY 2 TO ENTIER sqrt( UPB prime ) DO
        IF prime[ i ] THEN
            FOR s FROM i * i BY i + i TO UPB prime DO prime[ s ] := FALSE OD
        FI
    OD;
    # construct a table of ordered digits of primes                          #
    # pd[ i ] 0 if no prime with its digits in order = i,                    #
    #         > 0 if there is a group of primes with ordered digits = i      #
    #                pd[ i ] is then the final prime in the group            #
    #         < 0 if there is a group of primes with ordered digits = i      #
    #                ABS pd[ i ] is then the next prime in the group         #
    #         if i is not itself prime, the final element in the chain will  #
    #                be 0                                                    #
    [ 0 : max prime ]INT pd; FOR i FROM LWB pd TO UPB pd DO pd[ i ] := 0 OD;
    FOR p FROM UPB prime BY -1 TO LWB prime DO
        IF prime[ p ] THEN
            # have a prime - order its digits                                #
            [ 0 : 9 ]INT d count; FOR i FROM 0 TO 9 DO d count[ i ] := 0 OD;
            INT v := p;
            WHILE d count[ v MOD 10 ] +:= 1;
                  ( v OVERAB 10 ) > 0
            DO SKIP OD;
            # get the digits in descending order, so e.g.: 103 yields 310    #
            INT ordered digits := 0;
            FOR i FROM 9 BY -1 TO 0 DO
                TO d count[ i ] DO
                    ordered digits *:= 10 +:= i
                OD
            OD;
            IF pd[ ordered digits ] /= 0 THEN
                # there was a previous prime with these digits                #
                pd[ p ] := - pd[ ordered digits ]
            FI;
            pd[ ordered digits ] := p
        FI
    OD;
    # display information about the groups                                    #
    INT p10 := 10;
    WHILE p10 < max prime DO
        # find the groups in p10..p10*10                                      #
        INT min element  := 0;
        INT max element  := 0;
        INT group count  := 0;
        INT group length := 0;
        INT length count := 0;
        INT range end     = ( p10 * 10 ) - 1;
        FOR g FROM p10 TO range end DO
            IF pd[ g ] < 0 THEN
                # a group starts here                                         #
                group count        +:= 1;
                INT this max        := ABS pd[ g ];
                INT this length     := 2;
                WHILE pd[ this max ] < 0 DO
                    INT prev max    := this max;
                    this max        := ABS pd[ this max ];
                    this length    +:= 1;
                    pd[ prev max ]  := 0
                OD;
                IF this length > group length THEN
                    # found a longer group                                    #
                    IF pd[ this max ] > 0 THEN
                        min element := pd[ this max ]
                    ELSE
                        min element := g
                    FI;
                    max element     := this max;
                    group length    := this length;
                    length count    := 1
                ELIF this length = group length THEN
                    # have another group of the same length                   #
                    length count   +:= 1
                FI
            FI
        OD;
        print( ( "Anaprime groups in ", whole( p10,          0 )
               , "..",                  whole( range end,    0 )
               , ": ",                  whole( group count,  0 )
               , "; "
               , IF   group count = length count
                 THEN "all"
                 ELSE whole( length count, 0 )
                 FI
               , IF   length count = 1
                 THEN " has"
                 ELSE " have"
                 FI
               , " maximum length(",    whole( group length, 0 )
               , "), first: ",          whole( min element,  0 )
               , IF   group length = 2
                 THEN ", "
                 ELSE ", ... "
                 FI
               ,                        whole( max element,  0 )
               , newline
               )
             );
        p10 *:= 10
    OD
END
