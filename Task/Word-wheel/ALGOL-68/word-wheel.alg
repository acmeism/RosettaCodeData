STRING wheel = "ndeokgelw";

PROC check word = (STRING word, wheel)BOOL:
  IF UPB word >= 3 AND UPB word <= UPB wheel THEN
    STRING wh := wheel;
    FOR i TO UPB word DO
      CHAR ch = word[i];
      FOR j TO UPB wh DO
        IF ch = wh[j] THEN
          wh[j] := REPR 0;
          continue
        FI
      OD;
      return false;
      continue: SKIP
    OD;
    IF wh[UPB wh % 2 + 1] /= REPR 0 THEN return false FI;
    TRUE EXIT
    return false: FALSE
  ELSE
    FALSE
  FI;

BEGIN
  FILE f;
  BOOL eof := FALSE;
  open(f, "unixdict.txt", stand in channel);
  on logical file end(f, (REF FILE f)BOOL: eof := TRUE);
  WHILE ~eof DO
    STRING word;
    get(f, (word, new line));
    IF check word(word, wheel) THEN
      print((word, new line))
    FI
  OD
END
