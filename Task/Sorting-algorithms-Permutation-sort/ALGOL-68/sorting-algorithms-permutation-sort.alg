BEGIN # permutation sort - permutation code based on the EasyLang sample     #

    # generates an initial permutation of a to b                             #
    PRIO INITIALPERMUTATION = 9;
    OP   INITIALPERMUTATION = ( INT a, b )REF[]INT:
         BEGIN
            [ a : b ]INT p;
            FOR i FROM a TO b DO p[ i ] := i OD;
            HEAP[ a : b ]INT := p
         END # INITIALPERMURATION # ;

    # specify the priorities of the dyadic sorting operators                 #
    PRIO PERMUTE = 9, PERMUTATIONSORT = 9, =:= = 9;

    # swaps the values of a and b                                            #
    OP   =:= = ( REF INT a, b )VOID: BEGIN INT t := a; a := b; b := t END;

    # the following operators implement permutation sorting of arrays        #
    # of strings - aimilar operators could be defined to sort other          #
    # sorts of array ( or other sortable things )                            #

    # returns TRUE if the elements of a are in order, FALSE otherwise        #
    OP   INORDER = ( []STRING a )BOOL:
         BEGIN
             BOOL is ordered := TRUE;
             FOR i FROM LWB a + 1 TO UPB a WHILE is ordered := a[ i - 1 ] <= a[ i ] DO SKIP OD;
             is ordered
         END # INORDER # ;

    # swaps the values of a and b                                            #
    OP   =:= = ( REF STRING a, b )VOID: BEGIN STRING t := a; a := b; b := t END;

    # updates perm to the next permutation and permutes the elements of data #
    #         based on the EasyLang sample's nextperm                        #
    OP   PERMUTE = ( REF[]STRING data, REF[]INT perm )REF[]STRING:
         BEGIN
            INT lb = LWB perm;
            INT n := UPB perm;
            INT k := n - 1;
            WHILE k >= lb AND perm[ k + 1 ] <= perm[ k ] DO k -:= 1 OD;
            IF k >= lb THEN
                INT j := n;
                WHILE perm[ j ] <= perm[ k ] DO j -:= 1 OD;
                perm[ j ] =:= perm[ k ];
                data[ j ] =:= data[ k ];
                k +:= 1;
                WHILE k < n DO
                    perm[ k ] =:= perm[ n ];
                    data[ k ] =:= data[ n ];
                    k +:= 1;
                    n -:= 1
                OD
            FI;
            data
         END # PERMUTE # ;

    # permutation sorts a in-place                                      #
    OP   PERMUTATIONSORT = ( REF[]STRING a )REF[]STRING:
         BEGIN
            REF[]INT permutation = LWB a INITIALPERMUTATION UPB a;
            WHILE NOT INORDER a DO
                a PERMUTE permutation
            OD;
            a
         END # PERMUTATIONSORT # ;

    BEGIN # test the permutation sort                                   #

        []STRING data = ( "sphinx", "of", "black", "quartz", "judge", "my", "vow" );
        [ LWB data : UPB data ]STRING sortable := data;
        PERMUTATIONSORT sortable;
        FOR pos FROM LWB sortable TO UPB sortable DO
            print( ( " ", sortable[ pos ] ) )
        OD;
        print( ( newline ) )

    END

END
