STRING sa := "abc   ", sb := "ABC ";

# when comparing strings, Algol 68 ignores trailing blanks                    #
# so e.g. "a" = "a " is true                                                  #

# test procedure, prints message if condition is TRUE                         #
PROC test = ( BOOL condition, STRING message )VOID:
    IF condition THEN print( ( message, newline ) ) FI;

# equality?                                                                   #
test( sa = sb, "sa = sb" );
# inequality?                                                                 #
test( sa /= sb, "sa not = sb" );

# lexically ordered before?                                                   #
test( sa < sb, "sa < sb" );

# lexically ordered after?                                                    #
test( sa >s b, "sa > sb" );

# Algol 68's builtin string comparison operators are case-sensitive.          #
# To perform case insensitive comparisons, procedures or operators            #
# would need to be written                                                    #
# e.g.                                                                        #

# compare two strings, ignoring case                                          #
# Note the "to upper" PROC is an Algol 68G extension                          #
# It could be written in standard Algol 68 (assuming ASCII) as e.g.           #
#    PROC to upper = ( CHAR c )CHAR:                                          #
#         IF c < "a" OR c > "z" THEN c                                        #
#         ELSE REPR ( ( ABS c - ABS "a" ) + ABS "A" ) FI;                     #
PROC caseless comparison = ( STRING a, b )INT:
     BEGIN
         INT a max   = UPB a, b max  = UPB b;
         INT a pos  := LWB a, b pos := LWB b;
         INT result := 0;
         WHILE result = 0
           AND ( a pos <= a max OR b pos <= b max )
         DO
             CHAR a char := to upper( IF a pos <= a max THEN a[ a pos ] ELSE " " FI );
             CHAR b char := to upper( IF b pos <= b max THEN b[ b pos ] ELSE " " FI );
             result := ABS a char - ABS b char;
             a pos +:= 1;
             b pos +:= 1
         OD;
         IF result < 0 THEN -1 ELIF result > 0 THEN 1 ELSE 0 FI
     END ; # caseless comparison #

# compare two strings for equality, ignoring case                             #
PROC equal ignoring case = ( STRING a, b )BOOL: caseless comparison( a, b ) = 0;
# similar procedures for inequality and lexical ording ...                    #

test( equal ignoring case( sa, sb ), "sa = sb (ignoring case)" );


# Algol 68 is strongly typed - strings cannot be compared to e.g. integers    #
# unless procedures or operators are written, e.g.                            #
# e.g. OP = = ( STRING a, INT b )BOOL: a = whole( b, 0 );                     #
#      OP = = ( INT a, STRING b )BOOL: b = a;                                 #
# etc.                                                                        #

# Algol 68 also has <= and >= comparison operators for testing for            #
# "lexically before or equal" and "lexically after or equal"                  #
test( sa <= sb, "sa <= sb" );
test( sa >= sb, "sa >= sb" )

# there are no other forms of string comparison builtin to Algol 68           #
