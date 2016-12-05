# operator to turn two boolean values into an integer - name inspired by the COBOL sample #
PRIO ALSO = 1;
OP   ALSO = ( BOOL a, b )INT: IF a AND b THEN 1 ELIF a THEN 2 ELIF b THEN 3 ELSE 4 FI;

# using the above operator, we can use the standard CASE construct to provide the #
# required construct, e.g.:                                                       #
BOOL a := TRUE, b := FALSE;
CASE a ALSO b
  IN print( ( "both:    a and b are TRUE",  newline ) )
   , print( ( "first:   only a is TRUE",    newline ) )
   , print( ( "second:  only b is TRUE",    newline ) )
   , print( ( "neither: a and b are FALSE", newline ) )
ESAC
