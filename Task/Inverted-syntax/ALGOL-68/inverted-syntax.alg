# Inverted assignment                                                                       #
# Assignment in Algol 68 is via ":=" which is automaically provided for all modes (types)   #
# However we could define e.g. "=:" as an inverted assignment operator but we would need to #
# define a separate operator for each mode, e.g. for integers and strings:                  #
PRIO =: = 1;
OP   =: = ( INT a,    REF INT    b )REF INT:    b := a;
OP   =: = ( STRING a, REF STRING b )REF STRING: b := a;
OP   =: = ( CHAR   a, REF STRING b )REF STRING: b := a;
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
# We could define an operator called WHEN perhaps, that would execute its left operand if   #
# the right operand was TRUE. However the left operand would need to be a PROC VOID so the  #
# syntax would not be as convientent as the standard IF-THEN-FI construct. E.g.:            #
PRIO WHEN = 1;
OP   WHEN = ( PROC VOID code, BOOL test )VOID: IF test THEN code FI;

( VOID: print( ( "NO",  newline ) ) ) WHEN a = b;  # the anonymous PROC VOID is not called  #
( VOID: print( ( "yes", newline ) ) ) WHEN a /= b  # the anonymous PROC VOID is called      #
