# find some isograms ( words where each letter occurs the same number of     #
# times as the others ) and heterograms ( words where each letter occurs     #
# once ). Note a heterogram is an isogram of order 1                         #
IF  FILE input file;
    STRING file name = "unixdict.txt";
    open( input file, file name, stand in channel ) /= 0
THEN
    # failed to open the file #
    print( ( "Unable to open """ + file name + """", newline ) )
ELSE
    # file opened OK #
    BOOL at eof := FALSE;
    # set the EOF handler for the file - notes eof has been reached and      #
    # returns TRUE so processing can continue                                #
    on logical file end( input file, ( REF FILE f )BOOL: at eof := TRUE );

    # in-place quick sort an array of strings                                #
    PROC s quicksort = ( REF[]STRING a, INT lb, ub )VOID:
         IF ub > lb
         THEN
            # more than one element, so must sort                            #
            INT  left  := lb;
            INT  right := ub;
            # choosing the middle element of the array as the pivot          #
            STRING pivot := a[ left + ( ( right + 1 ) - left ) OVER 2 ];
            WHILE
                WHILE IF left  <= ub THEN a[ left  ] < pivot ELSE FALSE FI
                DO
                    left  +:= 1
                OD;
                WHILE IF right >= lb THEN a[ right ] > pivot ELSE FALSE FI
                DO
                    right -:= 1
                OD;
                left <= right
            DO
                STRING t   := a[ left  ];
                a[ left  ] := a[ right ];
                a[ right ] := t;
                left      +:= 1;
                right     -:= 1
            OD;
            s quicksort( a, lb,   right );
            s quicksort( a, left, ub    )
         FI # s quicksort # ;

    # returns the length of s                                                #
    OP LENGTH = ( STRING s )INT: 1 + ( UPB s - LWB s );
    # returns n if s is an isogram of order n, 0 if s is not an isogram      #
    OP ORDER  = ( STRING s )INT:
       BEGIN
        # count the number of times each character occurs                    #
        [ 0 : max abs char ]INT count;
        FOR i FROM LWB count TO UPB count DO count[ i ] := 0 OD;
        FOR i FROM LWB s TO UPB s DO
            CHAR c = s[ i ];
            IF c >= "A" AND c <= "Z" THEN
                # uppercase - treat as lower                                 #
                count[ ( ABS c - ABS "A" ) + ABS "a" ] +:= 1
            ELSE
                # lowercase or non-letter                                    #
                count[ ABS c ] +:= 1
            FI
        OD;
        INT order := -1;
        # check the characters all occur the same number of times            #
        FOR i FROM LWB count TO UPB count WHILE order /= 0 DO
            IF count[ i ] /= 0 THEN
                # have a characetr that appeared in s                        #
                IF   order = -1 THEN
                    # first character                                        #
                    order := count[ i ]
                ELIF order /= count[ i ] THEN
                    # character occured a different number of times to       #
                    # the previous one                                       #
                    order := 0
                FI
            FI
        OD;
        IF order < 0 THEN 0 ELSE order FI
       END # ORDER # ;
    [ 1 : 2 000 ]STRING words;
    INT   w count := 0;
    WHILE
        STRING word;
        get( input file, ( word, newline ) );
        NOT at eof
    DO
        # have another word                                                  #
        INT order = ORDER word;
        IF order > 0 THEN
            INT w length = LENGTH word;
            IF ( order = 1 AND w length > 10 ) OR order > 1 THEN
                # a long heterogram or an isogram                            #
                # store the word prefixed by the max abs char complement of  #
                # the order and the length so when sorted, the words are     #
                # ordered as requierd by the task                            #
                STRING s word = REPR ( max abs char - order    )
                              + REPR ( max abs char - w length )
                              + word;
                words[ w count +:= 1 ] := s word
            FI
        FI
    OD;
    close( input file );
    # sort the words                                                         #
    s quicksort( words, 1, w count );
    # display the words                                                      #
    INT prev order  := 0;
    INT prev length := 999 999;
    INT p count     := 0;
    FOR w TO w count DO
        STRING gram   = words[ w ];
        INT    order  = max abs char - ABS gram[ 1 ];
        INT    length = max abs char - ABS gram[ 2 ];
        STRING word   = gram[ 3 : ];
        IF order /= prev order THEN
            IF order = 1 THEN
                print( ( newline, "heterograms longer than 10 characters" ) )
            ELSE
                print( ( newline, "isograms of order ", whole( order, 0 ) ) )
            FI;
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
