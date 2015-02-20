    # fills lc with the 26 lower-case letters, assuming that               #
    # they are consecutive in the character set, as they are in ASCII      #

    [ 26 ]CHAR lc;

    FOR i FROM LWB lc TO UPB lc
    DO
        lc[ i ] := REPR ( ABS "a" + ( i - 1 ) )
    OD
