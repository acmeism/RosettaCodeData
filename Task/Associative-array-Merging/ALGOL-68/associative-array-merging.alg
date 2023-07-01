# associative array merging                                                  #

# the modes allowed as associative array element values - change to suit     #
MODE AAVALUE = UNION( STRING, INT, REAL );
# the modes allowed as associative array element keys - change to suit       #
MODE AAKEY   = STRING;
# initial value for an array element                                         #
AAVALUE init element value = "";

# include the associative array code                                         #
PR read "aArrayBase.a68" PR

# adds or replaces all elements from b into a                     #
PRIO UPDATE = 9;
OP UPDATE = ( REF AARRAY a, REF AARRAY b )REF AARRAY:
BEGIN
    REF AAELEMENT e := FIRST b;
    WHILE e ISNT nil element DO
        a // key OF e := value OF e;
        e := NEXT b
    OD;
    a
END # UPDATE # ;

# construct the associative arrays for the task                   #
REF AARRAY a := INIT LOC AARRAY;
REF AARRAY b := INIT LOC AARRAY;
a // "name"  := "Rocket Skates";
a // "price" := 12.75;
a // "color" := "yellow";
b // "price" := 15.25;
b // "color" := "red";
b // "year"  := 1974;
# merge the arrays                                                #
REF AARRAY c := INIT LOC AARRAY;
c UPDATE a UPDATE b;
# show the merged array                                           #
REF AAELEMENT e := FIRST c;
WHILE e ISNT nil element DO
    print( ( key OF e
           , ": "
           , CASE value OF e
               IN (STRING s): s
                , (INT    i): whole( i, 0 )
                , (REAL   r): fixed( r, -12, 2 )
              OUT "????"
             ESAC
           , newline
           )
         );
    e := NEXT c
OD
