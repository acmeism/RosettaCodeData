MODE DIETITEM = STRUCT (
  STRING food, annual quantity, units, REAL cost
);

MODE OBJVALUE = DIETITEM;

# PUSH element to stack #
OP +:= = (REF FLEX[]OBJVALUE stack, OBJVALUE item) VOID:
   BEGIN
      FLEX[UPB stack + 1]OBJVALUE newstack;
      newstack[2:UPB newstack] := stack;
      newstack[1] := item;
      stack := newstack
   END;

OP POP = (REF FLEX[]OBJVALUE stack) OBJVALUE:
   IF UPB stack > 0 THEN
      OBJVALUE result = stack[1];
      stack := stack[2:UPB stack];
      result
   ELSE
      # raise index error; # SKIP
   FI;

# Stigler's 1939 Diet ... #
FORMAT diet item fmt = $g": "g" "g" = $"zd.dd$;
[]DIETITEM stigler diet = (
  ("Cabbage",           "111","lb.",  4.11),
  ("Dried Navy Beans",  "285","lb.", 16.80),
  ("Evaporated Milk",    "57","cans", 3.84),
  ("Spinach",            "23","lb.",  1.85),
  ("Wheat Flour",       "370","lb.", 13.33),
  ("Total Annual Cost",    "","",    39.93)
);

FLEX[0]DIETITEM example stack;

FOR i TO UPB stigler diet DO
   example stack +:= stigler diet[i]
OD;

printf($"Items popped in reverse:"l$);
WHILE UPB example stack > 0 DO
  printf((diet item fmt, POP example stack, $l$))
OD
