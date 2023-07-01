# symetric difference using associative arrays to represent the sets         #
# include the associative array code for string keys and values              #
PR read "aArray.a68" PR

# adds the elements of s to the associative array a,                         #
#      the elements will have empty strings for values                       #
OP // = ( REF AARRAY a, []STRING s )REF AARRAY:
BEGIN
    FOR s pos FROM LWB s TO UPB s DO
        a // s[ s pos ] := ""
    OD;
    a
END # // # ;
# returns an AARRAY containing the elements of a that aren't in b            #
OP - = ( REF AARRAY a, REF AARRAY b )REF AARRAY:
BEGIN
    REF AARRAY result := INIT HEAP AARRAY;
    REF AAELEMENT e := FIRST a;
    WHILE e ISNT nil element DO
        IF NOT ( b CONTAINSKEY key OF e ) THEN
            result // key OF e := value OF e
        FI;
        e := NEXT a
    OD;
    result
END # - # ;
# returns an AARRAY containing the elements of a and those of b   #
#         i.e. in set terms a UNION b                             #
OP + = ( REF AARRAY a, REF AARRAY b )REF AARRAY:
BEGIN
    REF AARRAY result := INIT HEAP AARRAY;
    REF AAELEMENT e := FIRST a;
    WHILE e ISNT nil element DO
        result // key OF e := value OF e;
        e := NEXT a
    OD;
    e := FIRST b;
    WHILE e ISNT nil element DO
        result // key OF e := value OF e;
        e := NEXT b
    OD;
    result
END # + # ;
# construct the associative arrays for the task                   #
REF AARRAY a := INIT LOC AARRAY;
REF AARRAY b := INIT LOC AARRAY;
a // []STRING( "John", "Bob", "Mary", "Serena" );
b // []STRING( "Jim", "Mary", "John", "Bob" );
# find and show the symetric difference of a and b                #
REF AARRAY c := ( a - b ) + ( b - a );
REF AAELEMENT e := FIRST c;
WHILE e ISNT nil element DO
    print( ( " ", key OF e ) );
    e := NEXT c
OD;
print( ( newline ) )
