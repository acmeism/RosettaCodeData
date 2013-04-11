REF STRING no result = NIL;
STRING result := "";

IF no result :=: NIL THEN print(("no result :=: NIL", new line)) FI;
IF result :/=: NIL THEN print(("result :/=: NIL", new line)) FI;

IF no result IS NIL THEN print(("no result IS NIL", new line)) FI;
IF result ISNT NIL THEN print(("result ISNT NIL", new line)) FI;

COMMENT using the UNESCO/IFIP/WG2.1 ALGOL 68 character set
  result := °;
  IF REF STRING(result) :≠: ° THEN print(("result ≠ °", new line)) FI;
END COMMENT

# Note the following gotcha: #

REF STRING var := NIL;
IF var ISNT NIL THEN print(("The address of var ISNT NIL",new line)) FI;
IF var IS REF STRING(NIL) THEN print(("The address of var IS REF STRING(NIL)",new line)) FI
