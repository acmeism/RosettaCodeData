BEGIN # find some isograms ( words where each letter occurs the same number   #
      # of times as the others ) and heterograms ( words where each letter    #
      # occurs once ). Note a heterogram is an isogram of order 1             #

    PR read "files.incl.a68" PR                      # include file utilities #
    PR read  "sort.incl.a68" PR                      # include sort utilities #

    # returns the length of s                                                 #
    OP LENGTH = ( STRING s )INT: 1 + ( UPB s - LWB s );
    # returns n if s is an isogram of order n, 0 if s is not an isogram       #
    OP   ORDER  = ( STRING s )INT:
         BEGIN
            # count the number of times each character occurs                 #
            [ 0 : max abs char ]INT count;
            FOR i FROM LWB count TO UPB count DO count[ i ] := 0 OD;
            FOR i FROM LWB s TO UPB s DO
                CHAR c = s[ i ];
                IF c >= "A" AND c <= "Z" THEN    # uppercase - treat as lower #
                    count[ ( ABS c - ABS "A" ) + ABS "a" ] +:= 1
                ELSE                                # lowercase or non-letter #
                    count[ ABS c ] +:= 1
                FI
            OD;
            INT order := -1;
            # check the characters all occur the same number of times         #
            FOR i FROM LWB count TO UPB count WHILE order /= 0 DO
                IF count[ i ] /= 0 THEN # have a characetr that appeared in s #
                    IF   order = -1 THEN                    # first character #
                        order := count[ i ]
                    ELIF order /= count[ i ] THEN       # character occured a #
                        order := 0                # different number of times #
                                                        # to the previous one #
                    FI
                FI
            OD;
            IF order < 0 THEN 0 ELSE order FI
         END # ORDER # ;

    [ 1 : 2 000 ]STRING words;   # table if required isograms and heterograms #

    # stores word in words if it is an isogram or heterogram of more then 10  #
    # characters                                                              #
    # returns TRUE if word was stored, FALSE otherwise                        #
    # count so far will contain the number of poreceding matching words       #
    PROC store grams = ( STRING word, INT count so far )BOOL:
         IF   INT order = ORDER word;
              order < 1
         THEN FALSE                            # not an isogram or heterogram #
         ELIF INT w length = LENGTH word;
              order = 1 AND w length <= 10
         THEN FALSE                                        # short heterogram #
         ELSE # a long heterogram or an isogram                               #
              # store the word prefixed by the max abs char complement of the #
              # the order and the length so when sorted, the words are        #
              # ordered as requierd by the task                               #
              STRING s word = REPR ( max abs char - order    )
                            + REPR ( max abs char - w length )
                            + word;
              words[ count so far + 1 ] := s word;
              TRUE
         FI # store grams # ;

    IF INT   w count = "unixdict.txt" EACHLINE store grams;
       w count < 0
    THEN
        print( ( "Unable to open unixdict.txt", newline ) )
    ELSE
        words QUICKSORT ELEMENTS( 1, w count );              # sort the words #
        # display the words                                                   #
        INT prev order  :=       0;
        INT prev length := 999 999;
        INT p count     :=       0;
        FOR w TO w count DO
            STRING gram   = words[ w ];
            INT    order  = max abs char - ABS gram[ 1 ];
            INT    length = max abs char - ABS gram[ 2 ];
            STRING word   = gram[ 3 : ];
            IF order /= prev order THEN
                print( ( newline
                       , IF order = 1
                         THEN "heterograms longer than 10 characters"
                         ELSE "isograms of order " + whole( order, 0 )
                         FI
                       )
                     );
                prev order  := order;
                prev length := 999 999;
                p count     := 0
            FI;
            IF prev length > length OR p count > 5 THEN
                print( ( newline ) );
                prev length := length;
                p count     := 0
            FI;
            print( ( " " * IF length > 11 THEN 1 ELSE 13 - length FI, word ) );
            p count +:= 1
        OD
    FI

END
