CO
Wireworld implementation.
CO

PROC exception = ([]STRING args)VOID:(
  putf(stand error, ($"Exception"$, $", "g$, args, $l$));
  stop
);

PROC assertion error = (STRING message)VOID:exception(("assertion error", message));

MODE CELL = CHAR;
MODE WORLD = FLEX[0, 0]CELL;
CELL head="H", tail="t", conductor=".", empty = " ";
STRING all states := empty;

BOOL wrap = FALSE; # is the world round? #

STRING nl := REPR 10;

STRING in string :=
  "tH........."+nl+
  ".   ."+nl+
  "   ..."+nl+
  ".   ."+nl+
  "Ht.. ......"+nl
;

OP +:= = (REF FLEX[]FLEX[]CELL lines, FLEX[]CELL line)VOID:(
      [UPB lines + 1]FLEX[0]CELL new lines;
      new lines[:UPB lines]:=lines;
      lines := new lines;
      lines[UPB lines]:=line
);

PROC read file = (REF FILE in file)WORLD: (
    # file > initial world configuration" #
    FLEX[0]CELL line;
    FLEX[0]FLEX[0]CELL lines;
    INT upb x:=0, upb y := 0;
    BEGIN
      # on physical file end(in file, exit read line); #
      make term(in file, nl);
      FOR x TO 5 DO
        get(in file, (line, new line));
        upb x := x;
        IF UPB line > upb y THEN upb y := UPB line FI;
        lines +:= line
      OD;
    exit read line: SKIP
    END;
    [upb x, upb y]CELL out;
    FOR x TO UPB out DO
      out[x,]:=lines[x]+" "*(upb y-UPB lines[x])
    OD;
    out
);

PROC new cell = (WORLD current world, INT x, y)CELL: (
    CELL istate := current world[x, y];
    IF INT pos; char in string (istate, pos, all states); pos IS REF INT(NIL) THEN
        assertion error("Wireworld cell set to unknown value "+istate) FI;
    IF istate = head THEN
        tail
    ELIF istate = tail THEN
        conductor
    ELIF istate = empty THEN
        empty
    ELSE # istate = conductor #
        [][]INT dxy list = ( (-1,-1), (-1,+0), (-1,+1),
                             (+0,-1),          (+0,+1),
                             (+1,-1), (+1,+0), (+1,+1) );
        INT n := 0;
        FOR enum dxy TO UPB dxy list DO
          []INT dxy = dxy list[enum dxy];
          IF wrap THEN
            INT px = ( x + dxy[1] - 1 ) MOD 1 UPB current world + 1;
            INT py = ( y + dxy[2] - 1 ) MOD 2 UPB current world + 1;
            n +:= ABS (current world[px, py] = head)
          ELSE
            INT px = x + dxy[1];
            INT py = y + dxy[2];
            IF px >= 1 LWB current world AND px <= 1 UPB current world AND
               py >= 2 LWB current world AND py <= 2 UPB current world THEN
                 n +:= ABS (current world[px, py] = head)
            FI
          FI
        OD;
        IF 1 <= n AND n <= 2 THEN head ELSE conductor FI
    FI
);

PROC next gen = (WORLD world)WORLD:(
    # compute next generation of wireworld #
    WORLD new world := world;
    FOR x TO 1 UPB world DO
        FOR y TO 2 UPB world DO
            new world[x,y] := new cell(world, x, y)
        OD
    OD;
    new world
);

PROC world2string = (WORLD world) STRING:(
    STRING out:="";
    FOR x TO UPB world DO
      out +:= world[x,]+nl
    OD;
    out
);

FILE in file;
associate(in file, in string);

WORLD ww := read file(in file);
close(in file);

FOR gen TO 10 DO
    printf ( ($lg(-3)" "$, gen-1,  $g$,"="* (2 UPB ww-4), $l$));
    print ( world2string(ww) );
    ww := next gen(ww)
OD
