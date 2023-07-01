BOOL f = FALSE, t = TRUE;
[]BOOL ft = (f, t);
STRING or = " or ";
FOR key TO UPB ft DO
  BOOL val = ft[key];
  UNION(VOID, INT) void = (val|666|EMPTY);
  REF STRING ref = (val|HEAP STRING|NIL);
  INT int = ABS val;
  REAL real = ABS val;
  COMPL compl = ABS val;
  BITS bits = BIN ABS val; # or bitspack(val); #
  BYTES bytes = bytes pack((val|"?"|null char)*bytes width);
  CHAR char = (val|"?"|null char);
  STRING string = (val|"?"|"");

  print((((val | "TRUE" | "FALSE" ), ": ", val, or, (val|flip|flop), new line)));
  print(("  void: ", " => ", (void|(VOID):FALSE|TRUE), new line));
  print(("   ref: ", " => ", ref ISNT REF STRING(NIL), new line));
  print(("   int: ", int     , " => ", int /= 0, new line));
  print(("  real: ", real    , " => ", real /= 0, new line));
  print((" compl: ", compl   , " => ", compl /= 0, new line));
  print(("  bits: ", bits    , " => ", ABS bits /= 0, or, bits /= 2r0, or,
                     bits width ELEM bits, or, []BOOL(bits)[bits width], new line));
  print((" bytes: """, STRING(bytes)    , """ => ", 1 ELEM bytes /= null char, or,
                       STRING(bytes) /= null char*bytes width, or,
                       STRING(bytes)[1] /= null char, new line));
  print(("  char: """, char  , """ => ", ABS char /= 0 , or, char /= null char, new line));
  print(("string: """, string  , """ => ", string /= "", or, UPB string /= 0, new line));
  print((new line))
OD
