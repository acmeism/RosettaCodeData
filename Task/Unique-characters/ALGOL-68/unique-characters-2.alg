# helper functions #

PROC concat = ([]STRING strs)STRING:
  BEGIN
    STRING result := "";
    FOR i FROM LWB strs TO UPB strs DO
      result +:= strs[i]
    OD;
    result
  END;

PROC qsort = (REF STRING s, INT lo, hi)VOID:
  IF lo < hi THEN
    INT partition =
      BEGIN
        CHAR pivot = s[(lo + hi) % 2]; INT i := lo - 1, j := hi + 1;
        DO
          WHILE i +:= 1; i <= hi AND s[i] < pivot DO SKIP OD;
          WHILE j -:= 1; j >= lo AND s[j] > pivot DO SKIP OD;
          IF i >= j THEN return FI;
          CHAR tmp = s[i]; s[i] := s[j]; s[j] := tmp
        OD;
        return: j
      END;
    qsort(s, lo, partition);
    qsort(s, partition+1, hi)
  FI;

# actual solution #

STRING str := concat(("133252abcdeeffd",  "a6789798st",  "yxcdfgxcyz"));
qsort(str, 1, UPB str);

STRING unique := "";
CHAR ch := REPR 0;
INT count := 0;

FOR i FROM 1 TO UPB str DO
  IF str[i] = ch THEN
    count +:= 1
  ELSE
    IF count = 1 THEN unique +:= ch FI;
    ch := str[i]; count := 1
  FI
OD;
IF count = 1 THEN unique +:= ch FI;

print((unique, new line))
