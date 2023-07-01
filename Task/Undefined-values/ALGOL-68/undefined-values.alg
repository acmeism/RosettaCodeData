MODE R = REF BOOL;
R r := NIL;

MODE U = UNION(BOOL, VOID);
U u := EMPTY;

IF r IS R(NIL) THEN
  print(("r IS NIL", new line))
ELSE
  print(("r ISNT NIL", new line))
FI;

CASE u IN
  (VOID):print(("u is EMPTY", new line))
  OUT    print(("u isnt EMPTY", new line))
ESAC
