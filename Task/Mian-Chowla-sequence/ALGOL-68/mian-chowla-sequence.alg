# Find Mian-Chowla numbers: an
                     where: ai = 1,
                       and: an = smallest integer such that ai + aj is unique
                                             for all i, j in 1 .. n && i <= j
#
BEGIN
    INT max mc           = 100;
    [ max mc ]INT mc;
    INT curr size       :=      0; # initial size of the array     #
    INT size increment   = 10 000; # size to increase the array by #
    REF[]BOOL is sum    := HEAP[ 1 : 0 ]BOOL;
    INT mc count        := 1;
    FOR i WHILE mc count <= max mc DO
        # assume i will be part of the sequence                    #
        mc[ mc count ]  := i;
        # check the sums                                           #
        IF  ( 2 * i ) > curr size THEN
            # the is sum array is too small - make a larger one    #
            REF[]BOOL new sum = HEAP[ curr size + size increment ]BOOL;
            new sum[ 1 : curr size ] := is sum;
            FOR n TO size increment DO new sum[ curr size + n ] := FALSE OD;
            curr size  +:= size increment;
            is sum      := new sum
        FI;
        BOOL is unique  := TRUE;
        FOR mc pos TO mc count WHILE is unique := NOT is sum[ i + mc[ mc pos ] ] DO SKIP OD;
        IF is unique THEN
            # i is a sequence element - store the sums             #
            FOR k TO mc count DO is sum[ i + mc[ k ] ] := TRUE OD;
            mc count +:= 1
        FI
    OD;

    # print parts of the sequence                                  #
    print( ( "Mian Chowla sequence elements 1..30:", newline ) );
    FOR i TO 30 DO print( ( " ", whole( mc[ i ], 0 ) ) ) OD;
    print( ( newline ) );
    print( ( "Mian Chowla sequence elements 91..100:", newline ) );
    FOR i FROM 91 TO 100 DO print( ( " ", whole( mc[ i ], 0 ) ) ) OD

END
