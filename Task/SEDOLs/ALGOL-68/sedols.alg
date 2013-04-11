[]INT sedol weights = (1, 3, 1, 7, 3, 9);
STRING reject = "AEIOUaeiou";

PROC strcspn = (STRING s,reject)INT: (
  INT out:=0;
  FOR i TO UPB s DO
    IF char in string(s[i], LOC INT, reject) THEN
      return out
    FI;
    out:=i
  OD;
  return out: out
);

PROC sedol checksum = (REF STRING sedol6)INT:
(
  INT out;

  INT len := UPB sedol6;
  INT sum := 0;

  IF sedol6[len-1] = REPR 10 THEN len-:=1; sedol6[len]:=null char FI;
  IF len = 7 THEN
    putf(stand error, ($"SEDOL code already checksummed? ("g")"l$, sedol6));
    out := ABS ( BIN ABS sedol6[6] AND 16r7f); return out
  FI;
  IF len > 7 OR len < 6 OR strcspn(sedol6, reject) /= 6 THEN
    putf(stand error, ($"not a SEDOL code? ("g")"l$, sedol6));
    out := -1; return out
  FI;
  FOR i TO UPB sedol6 DO
    sum+:=sedol weights[i]*
      IF is digit(sedol6[i]) THEN
        ABS sedol6[i]- ABS "0"
      ELIF is alpha(sedol6[i]) THEN
        (ABS to upper(sedol6[i])-ABS "A") + 10
      ELSE
        putf(stand error, $"SEDOL with not alphanumeric digit"l$);
        out:=-1; return out
      FI
  OD;
  out := (10 - (sum MOD 10)) MOD 10 + ABS "0";
  return out: out
);

main:
(
  STRING line;

  on logical file end(stand in, (REF FILE f)BOOL: done);
  DO getf(stand in, ($gl$,line));
    INT sr := sedol checksum(line);
    IF sr > 0 THEN
      printf(($ggl$, line, REPR sedol checksum(line)))
    FI
  OD;
  done: SKIP
)
