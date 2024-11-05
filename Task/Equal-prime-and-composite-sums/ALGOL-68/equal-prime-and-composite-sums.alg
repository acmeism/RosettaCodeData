BEGIN # find n and m where the sums of the first n primes and first m         #
      # composites where the sums are equal                                   #

    MODE INTEGER = LONG INT;                        # size of INT MODE to use #
    OP   ROOT    = ( LONG INT n )LONG INT: ENTIER long sqrt( n );
    # alternative ROOT operators for different sizes of integer would be      #
    # needed in general, but not for this task, e.g.:                         #
CO  OP   ROOT    = (      INT n )INT:      ENTIER      sqrt( n );            CO


    PROC is prime = ( INTEGER n )BOOL:           # returns TRUE if n is prime #
         IF   n <= 2 THEN n = 2
         ELIF NOT ODD n THEN FALSE
         ELSE BOOL prime := TRUE;
              INTEGER  i := 1;
              INTEGER  r := ROOT n;
              WHILE ( i +:= 2 ) <= r AND prime DO prime := n MOD i /= 0 OD;
              prime
         FI # is prime # ;

    BEGIN
        INT     count := 0;
        INTEGER n := 2, m := 1, sum p := 5, sum c := 4, num p := 3, num c := 4;
        print( ( "             sum    primes composites", newline ) );
        WHILE IF sum c > sum p THEN
                  WHILE NOT is prime( num p +:= 2 ) DO SKIP OD;
                  sum p +:= num p;
                  n     +:= 1
              FI;
              IF sum p > sum c THEN
                  WHILE is prime( num c +:= 1 ) DO SKIP OD;
                  sum c +:= num c;
                  m     +:= 1
              FI;
              IF sum p = sum c THEN
                  print( ( whole( sum p, -16 ), whole( n, -10 ), whole( m, -11 ), newline ) );
                  count +:= 1;
                  IF count < 8 THEN
                      WHILE is prime( num c +:= 1 ) DO SKIP OD;
                      sum c +:= num c;
                      m     +:= 1
                  FI
              FI;
              count < 8
        DO SKIP OD
    END
END
