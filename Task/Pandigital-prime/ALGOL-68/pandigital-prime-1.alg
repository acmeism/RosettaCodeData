BEGIN # Find the largest n-digit prime that contains all the digits 1..n #
      # As noted in the Factor sample, only 7 and 4 digit primes need be #
      # considered: 1 is not prime, all 2, 3, 5, 6, 8 and 9 digit        #
      # pandigital numbers are divisible by 3                            #
      # Also find the largest n+1 digit prime that contains all the      #
      # digits 0..n (only 5 and 8 digit numbers need be considered as    #
      # the 0 digit does not affect divisibility by 3)                   #
    # permutation code from the Algol 68 Permutations by swapping task   #
    # entry - uses Heap's algorithm - based on the pseudo code on the    #
    # Wikipedia page for Heap's Algorithm                                #
    # generate permutations of a, the results are stored in p #
    PROC generate = ( INT k, REF[]INT a, REF[]INT p, REF INT p pos )VOID:
         IF k = 1 THEN
            INT last digit = a[ UPB a ];
            IF ODD last digit AND last digit /= 5 THEN
                # the number doesn't end in 2 or 5 so might be prime     #
                INT a value := a[ 0 ];
                FOR d TO UPB a DO
                   a value *:= 10 +:= a[ d ]
                OD;
                p[ p pos +:= 1 ] := a value
             FI
         ELSE
            # Generate permutations with kth unaltered #
            # Initially k = length a #
            generate( k - 1, a, p, p pos );
            # Generate permutations for kth swapped with each k-1 initial #
            FOR i FROM 0 TO k - 2 DO
                # Swap choice dependent on parity of k (even or odd) #
                INT swap item = IF ODD k THEN 0 ELSE i FI;
                INT t           = a[ swap item ];
                a[ swap item ] := a[ k - 1 ];
                a[ k - 1     ] := t;
                generate( k - 1, a, p, p pos )
            OD
         FI # generate # ;
    # generate permutations of a, p is used to hold the output #
    # returns the number of permutations stored #
    PROC permute digits = ( REF[]INT a, REF[]INT p )INT:
         BEGIN
            INT p pos := -1;
            generate( ( UPB a + 1 ) - LWB a, a[ AT 0 ], p[ AT 0 ], p pos );
            p pos
         END # permute digits # ;
    # Quicksorts in-place the array of integers a, from lb to ub #
    PROC quicksort = ( REF[]INT a, INT lb, ub )VOID:
         IF ub > lb THEN
            # more than one element, so must sort #
            INT left   := lb;
            INT right  := ub;
            # choosing the middle element of the array as the pivot #
            INT pivot  := a[ left + ( ( right + 1 ) - left ) OVER 2 ];
            WHILE
                WHILE IF left  <= ub THEN a[ left  ] < pivot ELSE FALSE FI DO left  +:= 1 OD;
                WHILE IF right >= lb THEN a[ right ] > pivot ELSE FALSE FI DO right -:= 1 OD;
                left <= right
            DO
                INT t      := a[ left  ];
                a[ left  ] := a[ right ];
                a[ right ] := t;
                left      +:= 1;
                right     -:= 1
            OD;
            quicksort( a, lb,   right );
            quicksort( a, left, ub    )
         FI # quicksort # ;
    # attenmpt to find the maximum pandigital prime with digits f..n, return it if found, 0 otherwise #
    PROC try pd prime = ( INT f, INT n )INT:
         BEGIN
            # array of digits to permute for the numbers #
            [ f : n ]INT digits; FOR i FROM LWB digits TO UPB digits DO digits[ i ] := i OD;
            # array to hold the permuted digits, there will be ( ( n + 1 ) - f)! elements #
            INT factorial n := 1; FOR i FROM 2 TO ( n + 1 ) - f DO factorial n *:= i OD;
            [ 0 : factorial n - 1 ]INT permuted digits;
            # permute the digits #
            INT p count = permute digits( digits, permuted digits );
            # sort the permuted numbers, assuming the prime is near the high end #
            quicksort( permuted digits, LWB permuted digits, p count );
            # try finding a prime - use trial division to test for primality #
            INT pd prime := 0;
            FOR p pos FROM p count BY -1 TO LWB permuted digits WHILE pd prime = 0 DO
                INT p = permuted digits[ p pos ];
                # we have onlt stored the odd numbers that don't end in 5 #
                # and we know they are not divisible by 3 #
                BOOL prime := TRUE;
                FOR i FROM 7 BY 2 TO ENTIER sqrt(p) WHILE prime := p MOD i /= 0 DO SKIP OD;
                IF prime THEN
                    # found a pandigital prime #
                    pd prime := p
                FI
            OD;
            pd prime
         END # try pd prime # ;
    # trys to find the maximem pandigital/pandigital0 prime #
    PROC find pd prime = ( INT first digit, STRING title )VOID:
         IF   # first try digits up to 7 then up to 4 if we can't find one with pt to 7 #
              INT pd prime := try pd prime( first digit, 7 );
              pd prime > 0
         THEN
            print( ( "max ", title, " prime: ", whole( pd prime, 0 ), newline ) )
         ELIF pd prime := try pd prime( first digit, 4 );
              pd prime > 0
         THEN
            print( ( "max ", title, " prime: ", whole( pd prime, 0 ), newline ) )
         ELSE
            print( ( "Can't find a ", title, " prime", newline ) )
         FI # find pd prime # ;
    # task #
    find pd prime( 1, "pandigital"  );
    find pd prime( 0, "pandigital0" )
END
