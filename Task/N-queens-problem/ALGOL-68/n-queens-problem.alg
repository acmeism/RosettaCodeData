INT ofs = 1, # Algol68 normally uses array offset of 1 #
    dim = 8; # dim X dim chess board #
[ofs:dim+ofs-1]INT b;

PROC unsafe = (INT y)BOOL:(
  INT i, t, x;
  x := b[y];
  FOR i TO y - LWB b DO
    t := b[y - i];
    IF t = x THEN break true
    ELIF t = x - i THEN break true
    ELIF t = x + i THEN break true
    FI
  OD;
  FALSE EXIT
break true:
  TRUE
);

INT s := 0;

PROC print board = VOID:(
  INT x, y;
  print((new line, "Solution # ", s+:=1, new line));
  FOR y FROM LWB b TO UPB b DO
    FOR x FROM LWB b TO UPB b DO
      print("|"+(b[y]=x|"Q"|: ODD(x+y)|"/"|" "))
    OD;
    print(("|", new line))
  OD
);

main: (
  INT y := LWB b;
  b[LWB b] := LWB b - 1;
  FOR i WHILE y >= LWB b DO
    WHILE
      b[y]+:=1;
  # BREAK # IF b[y] <= UPB b THEN unsafe(y) ELSE FALSE FI
    DO SKIP OD;
    IF b[y] <= UPB b  THEN
      IF y < UPB b THEN
        b[y+:=1] := LWB b - 1
      ELSE
        print board
      FI
    ELSE
      y-:=1
    FI
  OD
)
