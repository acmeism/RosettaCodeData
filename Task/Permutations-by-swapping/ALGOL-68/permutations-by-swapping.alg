BEGIN # Heap's algorithm for generating permutations - from the pseudo-code on the Wikipedia page #
    # generate permutations of a #
    PROC generate = ( INT k, REF[]INT a, REF INT swap count )VOID:
         IF k = 1 THEN
            output permutation( a, swap count )
         ELSE
            # Generate permutations with kth unaltered #
            # Initially k = length a #
            generate( k - 1, a, swap count );
            # Generate permutations for kth swapped with each k-1 initial #
            FOR i FROM 0 TO k - 2 DO
                # Swap choice dependent on parity of k (even or odd) #
                swap count +:= 1;
                INT swap item = IF ODD k THEN 0 ELSE i FI;
                INT t           = a[ swap item ];
                a[ swap item ] := a[ k - 1 ];
                a[ k - 1     ] := t;
                generate( k - 1, a, swap count )
            OD
         FI # generate # ;
    # generate permutations of a #
    PROC permute = ( REF[]INT a )VOID:
         BEGIN
            INT swap count := 0;
            generate( ( UPB a + 1 ) - LWB a, a[ AT 0 ], swap count )
         END # permute # ;

    # handle a permutation #
    PROC output permutation = ( REF[]INT a, INT swap count )VOID:
         BEGIN
            print( ( "[" ) );
            FOR i FROM LWB a TO UPB a DO
               print( ( whole( a[ i ], 0 ) ) );
               IF i = UPB a THEN print( ( "]" ) ) ELSE print( ( ", " ) ) FI
            OD;
            print( ( " sign: ", IF ODD swap count THEN "-1" ELSE " 1" FI, newline ) )
         END # output permutation # ;

    [ 1 : 3 ]INT a := ( 1, 2, 3 );
    permute( a )

END
