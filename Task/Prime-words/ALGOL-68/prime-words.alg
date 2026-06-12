BEGIN # find words whose character codes are primes                           #

    PR read "primes.incl.a68" PR                    # include prime utilities #
    PR read  "files.incl.a68" PR                    # include file  utilities #

    # construct a sieve of primes up to the maximum character code            #
    []BOOL prime = PRIMESIEVE max abs char;

    # returns TRUE if the characters of word all have prime character codes   #
    #         FALSE otherwise                                                 #
    # count so far is the count of matching words found before this word      #
    PROC show prime word = ( STRING word, INT count so far )BOOL:
         BEGIN BOOL is prime := FALSE;
               FOR w pos FROM LWB word TO UPB word
               WHILE ( is prime := prime[ ABS word[ w pos ] ] )
               DO SKIP OD;
               IF NOT is prime
               THEN FALSE
               ELSE print( ( whole( count so far + 1, -5 ) ) );
                    print( ( ": ", word, newline ) );
                    TRUE
               FI
         END # show prime word # ;

    IF "unixdict.txt" EACHLINE show prime word < 0 THEN
        print( ( "Unable to open unixdict.txt", newline ) )
    FI

END
