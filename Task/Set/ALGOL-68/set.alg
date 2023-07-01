# sets using associative arrays                                              #
# include the associative array code for string keys and values              #
PR read "aArray.a68" PR

# adds the elements of s to the set a,                                       #
#      the elements will have empty strings for values                       #
OP // = ( REF AARRAY a, []STRING s )REF AARRAY:
BEGIN
    FOR s pos FROM LWB s TO UPB s DO
        a // s[ s pos ] := ""
    OD;
    a
END # // # ;
# returns a set containing the elements of a that aren't in b                #
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
# returns a set containing the elements of a and those of b, i.e. a UNION b  #
PRIO U = 6;
OP   U = ( REF AARRAY a, REF AARRAY b )REF AARRAY:
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
END # U # ;
# returns a set containing the elements of a INTERSECTION b                  #
PRIO N = 6;
OP   N = ( REF AARRAY a, REF AARRAY b )REF AARRAY:
BEGIN
    REF AARRAY result := INIT HEAP AARRAY;
    REF AAELEMENT e := FIRST a;
    WHILE e ISNT nil element DO
        IF b CONTAINSKEY key OF e THEN
            result // key OF e := value OF e
        FI;
        e := NEXT a
    OD;
    result
END # N # ;
# returns TRUE if all the elements of a are in b, FALSE otherwise            #
OP <= = ( REF AARRAY a, REF AARRAY b )BOOL:
BEGIN
    BOOL result := TRUE;
    REF AAELEMENT e := FIRST a;
    WHILE result AND ( e ISNT nil element ) DO
        result := b CONTAINSKEY key OF e;
        e := NEXT a
    OD;
    result
END # <= # ;
# returns TRUE if all the elements of a are in b                             #
#             and all the elements of b are in a, FALSE otherwise            #
OP = = ( REF AARRAY a, REF AARRAY b )BOOL: a <= b AND b <= a;
# returns NOT ( a = b )                                                      #
OP /= = ( REF AARRAY a, REF AARRAY b )BOOL: NOT ( a = b );
# returns TRUE if all the elements of a are in b                             #
#         but not all the elements of b are in a, FALSE otherwise            #
OP < = ( REF AARRAY a, REF AARRAY b )BOOL: a <= b AND b /= a;

# prints the elements of a in no-particlar order                             #
PROC print set = ( REF AARRAY a )VOID:
BEGIN
    print( ( "[" ) );
    REF AAELEMENT e := FIRST a;
    WHILE e ISNT nil element DO
        print( ( " ", key OF e ) );
        e := NEXT a
    OD;
    print( ( " ]", newline ) )
END # print set # ;

# construct associative arrays for the task                                  #
REF AARRAY gas giants       := INIT LOC AARRAY;
REF AARRAY ice giants       := INIT LOC AARRAY;
REF AARRAY rocky planets    := INIT LOC AARRAY;
REF AARRAY inner planets    := INIT LOC AARRAY;
REF AARRAY moonless planets := INIT LOC AARRAY;
gas giants       // []STRING( "Jupiter", "Saturn"  );
ice giants       // []STRING( "Uranus",  "Neptune" );
rocky planets    // []STRING( "Mercury", "Venus", "Earth", "Mars" );
inner planets    // []STRING( "Mercury", "Venus", "Earth", "Mars" );
moonless planets // []STRING( "Mercury", "Venus"   );

print( ( "rocky planets   : " ) );print set( rocky planets    );
print( ( "inner planets   : " ) );print set( inner planets    );
print( ( "gas giants      : " ) );print set( gas giants       );
print( ( "ice giants      : " ) );print set( ice giants       );
print( ( "moonless planets: " ) );print set( moonless planets );
print( ( newline ) );

print( ( """Saturn"" is "
       , IF gas giants CONTAINSKEY "Saturn" THEN "" ELSE " not" FI
       , "in gas giants", newline
       )
     );
print( ( """Venus"" is "
       , IF gas giants CONTAINSKEY "Venus" THEN "" ELSE "not " FI
       , "in gas giants", newline
       )
     );
print( ( "gas giants UNION ice giants                : " ) );
print set( gas giants U ice giants );
print( ( "moonless planets INTERSECTION rocky planets: " ) );
print set( moonless planets N rocky planets );
print( ( "rocky planets \ moonless planets           : " ) );
print set( rocky planets - moonless planets );
print( ( "moonless planets <= rocky planets          : "
       , IF moonless planets <= rocky planets THEN "yes" ELSE "no" FI
       , newline
       )
     );
print( ( "moonless planets = rocky planets           : "
       , IF moonless planets = rocky planets THEN "yes" ELSE "no" FI
       , newline
       )
     );
print( ( "inner planets = rocky planets              : "
       , IF inner planets = rocky planets THEN "yes" ELSE "no" FI
       , newline
       )
     );
print( ( "moonless planets < rocky planets           : "
       , IF moonless planets < rocky planets THEN "yes" ELSE "no" FI
       , newline
       )
     );

# REF AARRAYs are mutable                                                    #

REF AARRAY all planets := inner planets U gas giants U ice giants;
print( ( "all planets                   : " ) );
print set( all planets );
print( ( "... after restoration of Pluto: " ) );
all planets // "Pluto";
print set( all planets )
