BEGIN # count DNA bases in a sequence                                        #
    # returns an array of counts of the characters in s that are in c        #
    #         an extra final element holds the count of characters not in c  #
    PRIO COUNT = 9;
    OP   COUNT = ( STRING s, STRING c )[]INT:
         BEGIN
            [ LWB c : UPB c + 1 ]INT results; # extra element for "other"    #
            [ 0     : 255       ]INT counts;  # only counts ASCII characters #
            FOR i FROM LWB counts  TO UPB counts  DO counts[  i ] := 0 OD;
            FOR i FROM LWB results TO UPB results DO results[ i ] := 0 OD;
            # count the occurrences of each ASCII character in s              #
            FOR i FROM LWB s TO UPB s DO
                IF INT ch pos = ABS s[ i ];
                   ch pos >= LWB counts AND ch pos <= UPB counts
                THEN
                    # have a character we can count                          #
                    counts[ ch pos ] +:= 1
                ELSE
                    # not an ASCII character ?                               #
                    results[ UPB results ] +:= 1
                FI
            OD;
            # return the counts of the required characters                   #
            # set the results for the expected characters and clear their    #
            # counts so we can count the "other" characters                  #
            FOR i FROM LWB results TO UPB results - 1 DO
                IF INT ch pos = ABS c[ i ];
                   ch pos >= LWB counts AND ch pos <= UPB counts
                THEN
                    results[ i ]     := counts[ ch pos ];
                    counts[ ch pos ] := 0
                FI
            OD;
            # count the "other" characters                                   #
            FOR i FROM LWB counts TO UPB counts DO
                IF counts[ i ] /= 0 THEN
                    results[ UPB results ] +:= counts[ i ]
                FI
            OD;
            results
         END; # COUNT #
    # returns the combined counts of the characters in the elements of s     #
    #         that are in c                                                  #
    #         an extra final element holds the count of characters not in c  #
    OP   COUNT = ( []STRING s, STRING c )[]INT:
         BEGIN
            [ LWB c : UPB c + 1 ]INT results;
            FOR i FROM LWB results TO UPB results DO results[ i ] := 0 OD;
            FOR i FROM LWB s TO UPB s DO
                []INT counts = s[ i ] COUNT c;
                FOR i FROM LWB results TO UPB results DO
                   results[ i ] +:= counts[ i ]
                OD
            OD;
            results
         END; # COUNT #
    # returns the length of s                                                #
    OP   LEN = ( STRING s )INT: ( UPB s - LWB s ) + 1;
    # count the bases in the required sequence                               #
    []STRING seq = ( "CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATG"
                   , "CTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTG"
                   , "AGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGAT"
                   , "GGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT"
                   , "CGATTCTGCTTATAACACTATGTTCTTATGAAATGGATGTTCTGAGTTGG"
                   , "TCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA"
                   , "TTTAATTTTTCTATATAGCGATCTGTATTTAAGCAATTCATTTAGGTTAT"
                   , "CGCCGCGATGCTCGGTTCGGACCGCCAAGCATCTGGCTCCACTGCTAGTG"
                   , "TCCTAAATTTGAATGGCAAACACAAATAAGATTTAGCAATTCGTGTAGAC"
                   , "GACCGGGGACTTGCATGATGGGAGCAGCTTTGTTAAACTACGAACGTAAT"
                   );
    STRING bases  = "ATCG";
    []INT  counts = seq COUNT bases;
    # print the sequence with leading character positions                    #
    # find the overall length of the sequence                                #
    INT   seq len := 0;
    FOR i FROM LWB seq TO UPB seq DO
        seq len +:= LEN seq[ i ]
    OD;
    # compute the minimum field width required for the positions             #
    INT   s len   := seq len;
    INT   width   := 1;
    WHILE  s len >= 10 DO
        width +:= 1;
        s len OVERAB 10
    OD;
    # show the sequence                                                      #
    print( ( "Sequence:", newline, newline ) );
    INT start := 0;
    FOR i FROM LWB seq TO UPB seq DO
        print( ( " ", whole( start, - width ), " :", seq[ i ], newline ) );
        start +:= LEN seq[ i ]
    OD;
    # show the base counts                                                   #
    print( ( newline, "Bases: ", newline, newline ) );
    INT total := 0;
    FOR i FROM LWB bases TO UPB bases DO
        print( ( "  ", bases[ i ], "  : ", whole( counts[ i ], - width ), newline ) );
        total +:= counts[ i ]
    OD;
    # show the count of other characters (invalid bases) - if there are any  #
    IF INT others = UPB counts;
       counts[ others ] /= 0
    THEN
        # there were characters other than the bases                         #
        print( ( newline, "Other: ", whole( counts[ others ], - width ), newline, newline ) );
        total +:= counts[ UPB counts ]
    FI;
    # totals                                                                 #
    print( ( newline, "Total: ", whole( total, - width ), newline ) )
END
