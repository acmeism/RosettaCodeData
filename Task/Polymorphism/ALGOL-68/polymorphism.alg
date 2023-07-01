# Algol 68 provides for polymorphic operators but not procedures             #

# define the CIRCLE and POINT modes                                          #
MODE POINT  = STRUCT( REAL x, y    );
MODE CIRCLE = STRUCT( REAL x, y, r );


# PRINT operator                                                             #
OP PRINT = ( POINT  p )VOID: print( ( "Point(", x OF p, ",", y OF p, ")" ) );
OP PRINT = ( CIRCLE c )VOID: print( ( "Circle(", r OF c, " @ ", x OF c, ",", y OF c, ")" ) );

# getters                                                                    #
OP XCOORD = ( POINT p )REAL: x OF p;
OP YCOORD = ( POINT p )REAL: y OF p;

OP XCOORD = ( CIRCLE c )REAL: x OF c;
OP YCOORD = ( CIRCLE c )REAL: y OF c;
OP RADIUS = ( CIRCLE c )REAL: r OF c;

# setters                                                                    #
# the setters are dyadic operators so need a priority - we make them lowest  #
# priority, like PLUSAB etc.                                                 #
# They could have the same names as the getters but this seems clearer?      #
PRIO SETXCOORD = 1
   , SETYCOORD = 1
   , SETRADIUS = 1
   ;
# the setters return the POINT/CIRCLE being modified so we can write e.g.    #
# "PRINT ( p SETXCOORD 3 )"                                                  #
OP   SETXCOORD = ( REF POINT  p, REAL x )REF POINT:  ( x OF p := x; p );
OP   SETYCOORD = ( REF POINT  p, REAL y )REF POINT:  ( y OF p := y; p );

OP   SETXCOORD = ( REF CIRCLE c, REAL x )REF CIRCLE: ( x OF c := x; c );
OP   SETYCOORD = ( REF CIRCLE c, REAL y )REF CIRCLE: ( y OF c := y; c );
OP   SETRADIUS = ( REF CIRCLE c, REAL r )REF CIRCLE: ( r OF c := r; c );

# operands of an operator are not automatically coerced from INT to REAL so  #
# we also need these operators                                               #
OP   SETXCOORD = ( REF POINT  p, INT  x )REF POINT:  ( x OF p := x; p );
OP   SETYCOORD = ( REF POINT  p, INT  y )REF POINT:  ( y OF p := y; p );

OP   SETXCOORD = ( REF CIRCLE c, INT  x )REF CIRCLE: ( x OF c := x; c );
OP   SETYCOORD = ( REF CIRCLE c, INT  y )REF CIRCLE: ( y OF c := y; c );
OP   SETRADIUS = ( REF CIRCLE c, INT  r )REF CIRCLE: ( r OF c := r; c );

# copy constructors                                                          #
# A copy constructor is not needed as assignment will generate a copy        #
# e.g.: "POINT pa, pb; pa := ...; pb := pa; ..." will make pb a copy of pa   #

# assignment                                                                 #
# It is not possible to redefine the assignment "operator" in Algol 68 but   #
# assignment is automatically provided so no code need be written for e.g.   #
# "CIRCLE c1 := ...."                                                        #

# destructors                                                                #
# Algol 68 does not include destructors. A particular postlude could,        #
# in theory be provided if specific cleanup was requried, but this would     #
# occur at the end of the program, not at the end of the lifetime of the     #
# object.                                                                    #

# default constructor                                                        #
# Algol 68 automatically provides generators HEAP and LOC, which will        #
# create new objects of the specified MODE, e.g. HEAP CIRCLE will create a   #
# new CIRCLE. HEAP allocates apace on the heap, LOC allocates in on the      #
# stack (so the new item disappears when the enclosing block procedure or    #
# operator finishes)                                                         #

# a suitable "display" (value list enclosed in "(" and ")") can be cast to   #
# the relevent MODE, allowing us to write e.g.:                              #
# "POINT( 3.1, 2.2 )" where we need a new item.                              #

# "constructors" with other than all the fields in the correct order could   #
# be provided as procedures but each would need a distinct name              #
# e.g.                                                                       #
PROC new circle at the origin = ( REAL r )REF CIRCLE:
      ( ( HEAP CIRCLE SETRADIUS r ) SETXCOORD 0 ) SETYCOORD 0;
PROC new point at the origin = REF POINT:
      ( HEAP POINT SETXCOORD 0 ) SETYCOORD 0;


# examples of use                                                            #

BEGIN

    CIRCLE c1 := CIRCLE( 1.1, 2.4, 4.1 );
    POINT  p1 := new point at the origin;

    PRINT c1; newline( stand out );

    # move c1 so it is centred on p1                                         #
    ( c1 SETXCOORD XCOORD p1 ) SETYCOORD YCOORD p1;

    PRINT c1; newline( stand out )

END
