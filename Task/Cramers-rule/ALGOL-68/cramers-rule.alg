# returns the solution of a.x = b via Cramer's rule                    #
#         this is for REAL arrays, could define additional operators   #
#         for INT, COMPL, etc.                                         #
PRIO CRAMER = 1;
OP   CRAMER = ( [,]REAL a, []REAL b )[]REAL:
     IF 1 UPB a /= 2 UPB a
     OR 1 LWB a /= 2 LWB a
     OR 1 UPB a /=   UPB b
     THEN
        # the array sizes and bounds do not match                       #
        print( ( "Invaid parameters to CRAMER", newline ) );
        stop
     ELIF REAL deta = DET a;
          det a = 0
     THEN
        # a is singular                                                 #
        print( ( "Singular matrix for CRAMER", newline ) );
        stop
     ELSE
        # the arrays have matching bounds                               #
        [ LWB b : UPB b ]REAL result;
        FOR col FROM LWB b TO UPB b DO
            # form a matrix from a with the col'th column replaced by b #
            [ 1 LWB a : 1 UPB a, 2 LWB a : 2 UPB a ]REAL m := a;
            m[ : , col ] := b[ : AT 1 ];
            # col'th result elemet as per Cramer's rule                 #
            result[ col ] := DET m / det a
        OD;
        result
     FI; # CRAMER #

# test CRAMER using the matrix and column vector specified in the task  #
[,]REAL a = ( (  2, -1,  5,  1 )
            , (  3,  2,  2, -6 )
            , (  1,  3,  3, -1 )
            , (  5, -2, -3,  3 )
            );
[]REAL  b = (  -3
            , -32
            , -47
            ,  49
            );
[]REAL  solution = a CRAMER b;
FOR c FROM LWB solution TO UPB solution DO
    print( ( " ", fixed( solution[ c ], -8, 4 ) ) )
OD;
print( ( newline ) )
