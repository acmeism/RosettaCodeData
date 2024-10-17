# Inverted assignment                                                                       #
# Assignment in Algol 68 is via ":=" which is automaically provided for all modes (types)   #
# However we could define e.g. "=:" as an inverted assignment operator but we would need to #
# define a separate operator for eaach mode, e.g. for integers and strings:                 #
# also note that although "a := b := c" works as expected ( a and b get set to c )          #
# brckets are need to make "c =: b =: a" work as expected, i.e. ( c =: b ) =: a             #
PRIO =: = 1;
OP   =: = ( INT ia a,    REF INT    ia b )REF INT:    ia b := ia a;
OP   =: = ( STRING ia a, REF STRING ia b )REF STRING: ia b := ia a;
OP   =: = ( CHAR   ia a, REF STRING ia b )REF STRING: ia b := ia a;

# examples                                                                                  #
INT a, b; STRING s;
    1 =: a;
a + 1 =: b;
  "?" =: s;
print( ( a, b, s, newline ) );

# There is one standard inverted assignment operator: +=: or PLUSTO which prepends a string #
# to another:                                                                               #
"bc"  =: s;
"b"  +=: s;
print( ( s, newline ) );

# Inverted Conditional Expressions                                                          #
# We cuold define an operator called WHEN perhaps, that would execute its left operand if   #
# the right operand was TRUE. However the left operand would need to be a PROC VOID so the  #
# syntax would not be as conventient as the standard IF-THEN-FI construct. E.g.:            #
PRIO WHEN = 1;
OP   WHEN = ( PROC VOID code, BOOL test )VOID: IF test THEN code FI;

( VOID: print( ( "NO",  newline ) ) ) WHEN a = b;  # the anonymous PROC VOID is not called  #
( VOID: print( ( "yes", newline ) ) ) WHEN a /= b  # the anonymous PROC VOID is called      #
