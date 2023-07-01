# find some Ludic numbers                                #

# sieve the Ludic numbers up to 30 000                   #
INT   max number = 30 000;
[ 1 : max number ]INT candidates;
FOR n TO UPB candidates DO candidates[ n ] := n OD;
FOR n FROM 2 TO UPB candidates OVER 2 DO
    IF candidates[ n ] /= 0 THEN
        # have a ludic number                             #
        INT number count := -1;
        FOR remove pos FROM n TO UPB candidates DO
            IF candidates[ remove pos ] /= 0 THEN
                # have a number we haven't elminated yet  #
                number count +:= 1;
                IF number count = n THEN
                    # this number should be removed       #
                    candidates[ remove pos ] := 0;
                    number count := 0
                FI
            FI
        OD
    FI
OD;
# show some Ludic numbers and counts                      #
print( ( "Ludic numbers: " ) );
INT ludic count :=  0;
FOR n TO UPB candidates DO
    IF candidates[ n ] /= 0 THEN
        # have a ludic number                             #
        ludic count +:= 1;
        IF ludic count < 26 THEN
            # this is one of the first few Ludic numbers  #
            print( ( " ", whole( n, 0 ) ) );
            IF ludic count = 25 THEN
                print( ( " ...", newline ) )
            FI
        FI;
        IF ludic count = 2000 THEN
            print( ( "Ludic numbers 2000-2005: ", whole( n, 0 ) ) )
        ELIF ludic count > 2000 AND ludic count < 2006 THEN
            print( ( " ", whole( n, 0 ) ) );
            IF ludic count = 2005 THEN
                print( ( newline ) )
            FI
        FI
    FI;
    IF n = 1000 THEN
        # count ludic numbers up to 1000                  #
        print( ( "There are ", whole( ludic count, 0 ), " Ludic numbers up to 1000", newline ) )
    FI
OD;
# find the Ludic triplets below 250                        #
print( ( "Ludic triplets below 250:", newline ) );
FOR n TO 250 - 6 DO
    IF candidates[ n ] /= 0 AND candidates[ n + 2 ] /= 0 AND candidates[ n + 6 ] /= 0 THEN
        # have a triplet                                   #
        print( ( "    ", whole( n, -3 ), ", ", whole( n + 2, -3 ), ", ", whole( n + 6, -3 ), newline ) )
    FI
OD
