MODE OBJ = STRUCT(
  INT value,
  STRUCT(
    STRING message,
    FLEX[0]STRING args,
    PROC(REF OBJ)BOOL u0, u1
  ) exception
);

PROC on u0 = (REF OBJ self, PROC (REF OBJ) BOOL mended)VOID:
  u0 OF exception OF self := mended;

PROC on u1 = (REF OBJ self, PROC (REF OBJ) BOOL mended)VOID:
  u1 OF exception OF self := mended;

PRIO INIT = 1, RAISE = 1;

OP INIT = (REF OBJ self, INT value)REF OBJ: (
  value OF self := value;
  u0 OF exception OF self := u1 OF exception OF self := (REF OBJ skip)BOOL: FALSE;
  args OF exception OF self := message OF exception OF self := "OBJ Exception";
  self
);

OP RAISE = (REF OBJ self, PROC (REF OBJ) BOOL mended)VOID:
  IF NOT mended(self) THEN
    put(stand error, (message OF exception OF self+" not caught - stop", new line));
    stop
  FI;

PROC (REF OBJ)VOID bar, baz; # early declaration is required by the ALGOL 68RS subset language #

PROC foo := VOID:(
    FOR value FROM 0 TO 1 DO
        REF OBJ i = LOC OBJ INIT value;
        on u0(i, (REF OBJ skip)BOOL: (GO TO except u0; SKIP ));
            bar(i);
        GO TO end on u0;
        except u0:
            print(("Function foo caught exception u0", new line));
        end on u0: SKIP
    OD
);

# PROC # bar := (REF OBJ i)VOID:(
    baz(i) # Nest those calls #
);

# PROC # baz := (REF OBJ i)VOID:
    IF value OF i = 0 THEN
        i RAISE u0 OF exception OF i
    ELSE
        i RAISE u1 OF exception OF i
    FI;

foo
