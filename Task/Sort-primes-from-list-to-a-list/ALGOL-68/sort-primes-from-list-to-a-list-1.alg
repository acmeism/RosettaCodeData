BEGIN # extract the elements of a list that are prime and sort them           #
    PR read "primes.incl.a68" PR                    # include prime utilities #
    PR read "rows.incl.a68"   PR              # include row (array) utilities #
    PR read "sort.incl.a68"   PR                  # include sorting utilities #
    # list of numbers required by the task #
    []INT list = (  2, 43, 81, 122, 63, 13, 7, 95, 103 );
    [ 1 : UPB list ]INT prime list;
    # count the nunber of primes in list and assign the primes to prime list  #
    INT p count := 0;
    FOR i TO UPB list DO
        IF is probably prime( list[ i ] ) THEN
            # have a prime #
            prime list[ p count +:= 1 ] := list[ i ]
        FI
    OD;
    print( ( "prime elements of: " ) );
    SHOW list;
    print( ( newline, "              are: " ) );
    SHOW ( prime list QUICKSORT ELEMENTS( 1, p count ) )[ 1 : p count ]
END
