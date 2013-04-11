MODE SORTSTRUCT = CHAR;

PROC inplace gnome sort = (REF[]SORTSTRUCT list)REF[]SORTSTRUCT:
BEGIN
  INT i:=LWB list + 1, j:=LWB list + 2;
  WHILE i <= UPB list DO
    IF list[i-1] <= list[i] THEN
      i := j; j+:=1
    ELSE
      SORTSTRUCT swap = list[i-1]; list[i-1]:= list[i]; list[i]:= swap;
      i-:=1;
      IF i=LWB list THEN i:=j; j+:=1 FI
    FI
  OD;
  list
END;

PROC gnome sort = ([]SORTSTRUCT seq)[]SORTSTRUCT:
  in place gnome sort(LOC[LWB seq: UPB seq]SORTSTRUCT:=seq);

[]SORTSTRUCT char array data = "big fjords vex quick waltz nymph";
print((gnome sort(char array data), new line))
