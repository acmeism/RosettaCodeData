# calculate some details of "Fibonacci Words"               #

# fibonacci word 1 = "1"                                    #
# fibonacci word 2 = "0"                                    #
#                3 = word 2 cat word 1 = "01"               #
#                n = word n-1 cat word n-2                  #

# note the words contain only the characters "0" and "1"    #
# also                                                      #
#    C(word n) = C(word n-1) + C(word n-2)                  #
#           where C(x) = the number of characters in x      #
# Similarly,                                                #
#      C0(word n) = C0(word n-1) + C0(word n-2)             #
# and  C1(word n) = C1(word n-1) + C1(word n-2)             #
#      where C0(x) = the number of "0"s in x and            #
#            C1(x) = the number of "1"s in x                #

# we therefore don't have to calculate the words themselves #


# prints the statistics for the fibonacci words from 1 to max number #
PROC print fibonacci word stats = ( INT max number )VOID:
BEGIN

    # prints some statistics for a fibonacci word:                   #
    #        the word number, its length and its entropy             #
    PROC print one words stats = ( INT word
                                 , INT zeros
                                 , INT ones
                                 )VOID:
    BEGIN
        REAL probability := 0;
        REAL entropy     := 0;
        INT  word length  = zeros + ones;
        IF zeros > 0
        THEN
            # the word contains some zeros #
            probability := zeros / word length;
            entropy    -:= probability * log( probability )
        FI;
        IF ones > 0
        THEN
            # the word contains some ones #
            probability := ones  / word length;
            entropy    -:= probability * log( probability )
        FI;
        # we want entropy in bits so convert to log base 2 #
        entropy /:= log( 2 );
        print( ( whole( word, -5 ), " ", whole( word length, -12 ) ) );
        print( ( " ", fixed( entropy, -8, 4 ), newline ) )
    END; # print one words stats #

    INT zeros one     = 0; # number of zeros in word 1 #
    INT ones  one     = 1; # number of ones  in word 1 #
    INT zeros two     = 1; # number of zeros in word 2 #
    INT ones  two     = 0; # number of ones  in word 2 #
    print( ( " word       length  entropy", newline ) );
    IF max number > 0
    THEN
        # we want at least one number's statistics #
        print one words stats( 1, zeros one, ones one );
        IF max number > 1
        THEN
            # we want at least 2 number's statistics #
            print one words stats( 2, zeros two, ones two );
            IF max number > 2
            THEN
                # we want more statistics #
                INT zeros n minus 1 := zeros two;
                INT ones  n minus 1 := ones  two;
                INT zeros n minus 2 := zeros one;
                INT ones  n minus 2 := ones  one;
                FOR word FROM 3 TO max number DO
                    INT zeros n := zeros n minus 1 + zeros n minus 2;
                    INT ones  n := ones  n minus 1 + ones  n minus 2;
                    print one words stats( word, zeros n, ones n );
                    zeros n minus 2 := zeros n minus 1;
                    ones  n minus 2 := ones  n minus 1;
                    zeros n minus 1 := zeros n;
                    ones  n minus 1 := ones  n
                OD
            FI
        FI
    FI
END; # print fibonacci word stats #

# print the statistics for the first 37 fibonacci words #
print fibonacci word stats( 37 )
