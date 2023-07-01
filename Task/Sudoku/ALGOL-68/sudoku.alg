MODE AVAIL = [9]BOOL;
MODE BOX = [3, 3]CHAR;

FORMAT row fmt = $"|"3(" "3(g" ")"|")l$;
FORMAT line = $"+"3(7"-","+")l$;
FORMAT puzzle fmt = $f(line)3(3(f(row fmt))f(line))$;

AVAIL gen full = (TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE);

OP REPR = (AVAIL avail)STRING: (
  STRING out := "";
  FOR i FROM LWB avail TO UPB avail DO
    IF avail[i] THEN out +:= REPR(ABS "0" + i) FI
  OD;
  out
);

CHAR empty = "_";

OP -:= = (REF AVAIL set, CHAR index)VOID: (
  set[ABS index - ABS "0"]:=FALSE
);

#  these two functions assume that the number has not already been found #
PROC avail slice = (REF[]CHAR slice, REF AVAIL available)REF AVAIL:(
        FOR ele FROM LWB slice TO UPB slice DO
                IF slice[ele] /= empty THEN available-:=slice[ele] FI
        OD;
        available
);

PROC avail box = (INT x, y, REF AVAIL available)REF AVAIL:(
        #  x designates row, y designates column #
        #  get a base index for the boxes #
        INT bx := x - (x-1) MOD 3;
        INT by := y - (y-1) MOD 3;
        REF BOX box = puzzle[bx:bx+2, by:by+2];
        FOR i FROM LWB box TO UPB box DO
          FOR j FROM 2 LWB box TO 2 UPB box DO
                IF box[i, j] /= empty THEN available-:=box[i, j] FI
          OD
        OD;
        available
);

[9, 9]CHAR puzzle;
PROC solve = ([,]CHAR in puzzle)VOID:(
        puzzle := in puzzle;
        TO UPB puzzle UP 2 DO
                BOOL done := TRUE;
                FOR i FROM LWB puzzle TO UPB puzzle DO
                  FOR j FROM 2 LWB puzzle TO 2 UPB puzzle DO
                    CHAR ele := puzzle[i, j];
                    IF ele = empty THEN
                        #  poke at the elements that are "_" #
                        AVAIL remaining := avail box(i, j,
                                           avail slice(puzzle[i, ],
                                           avail slice(puzzle[, j],
                                           LOC AVAIL := gen full)));
                        STRING s = REPR remaining;
                        IF UPB s = 1 THEN puzzle[i, j] := s[LWB s]
                        ELSE done := FALSE
                        FI
                    FI
                  OD
                OD;
                IF done THEN break FI
        OD;
break:
        #  write out completed puzzle #
        printf(($gl$, "Completed puzzle:"));
        printf((puzzle fmt, puzzle))
);
main:(
   solve(("394__267_",
          "___3__4__",
          "5__69__2_",
          "_45___9__",
          "6_______7",
          "__7___58_",
          "_1__67__8",
          "__9__8___",
          "_264__735"))
CO # note: This codes/algorithm does not [yet] solve: #
   solve(("9__2__5__",
          "_4__6__3_",
          "__3_____6",
          "___9__2__",
          "____5__8_",
          "__7__4__3",
          "7_____1__",
          "_5__2__4_",
          "__1__6__9"))
END CO
)
