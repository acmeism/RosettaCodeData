# returns the subscripts of a pair of numbers in a that sum to sum, a is assumed to be sorted #
# if there isn't a pair of numbers that summs to sum, an empty array is returned              #
PRIO TWOSUM = 9;
OP   TWOSUM = ( []INT a, INT sum )[]INT:
     BEGIN
        BOOL found := FALSE;
        INT i := LWB a;
        INT j := UPB a;
        WHILE i < j AND NOT found DO
            INT s = a[ i ] + a[ j ];
            IF s = sum THEN
                found  := TRUE
            ELIF s < sum THEN
                i +:= 1
            ELSE
                j -:= 1
            FI
        OD;
        IF found THEN ( i, j ) ELSE () FI
     END # TWOSUM # ;

# test the TWOSUM operator #
PROC print twosum = ( []INT a, INT sum )VOID:
     BEGIN
         []INT pair = a[ AT 0 ] TWOSUM sum;
         IF LWB pair > UPB pair THEN
             # no pair with the required sum #
             print( ( "[]", newline ) )
         ELSE
             # have a pair #
             print( ( "[", whole( pair[ LWB pair ], 0 ), ", ", whole( pair[ UPB pair ], 0 ), "]", newline ) )
         FI
     END # print twosum # ;
print twosum( (  0, 2, 11, 19, 90 ),         21 ); # should be [1, 3]             #
print twosum( ( -8, -2,  0,  1,  5, 8, 11 ),  3 ); # should be [0, 6] (or [1, 4]) #
print twosum( ( -3, -2,  0,  1,  5, 8, 11 ), 17 ); # should be []                 #
print twosum( ( -8, -2, -1,  1,  5, 9, 11 ),  0 )  # should be [2, 3]             #
