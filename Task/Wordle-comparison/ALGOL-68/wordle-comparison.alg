# utility functions: #

PROC join = ([]STRING row, STRING joiner) STRING:
  BEGIN
    BOOL first := TRUE;
    STRING result := "";
    FOR i FROM LWB row TO UPB row DO
      IF NOT first THEN result +:= joiner
                   ELSE first := FALSE
      FI;
      result +:= row[i]
    OD;
    result
  END;

PROC fill = (REF []STRING row, STRING s) VOID:
  BEGIN
    FOR i FROM LWB row TO UPB row DO row[i] := s OD
  END;

# actual solution: #

PROC wordle comparison = (STRING word, guess) []STRING:
  BEGIN
    STRING copy := word;
    # we'll just replace matched chars with NULs in copy
      to avoid further matches #
    [UPB guess]STRING result;
    fill(result, "");
    # first the greens: #
    FOR i TO UPB guess DO
      IF i <= UPB copy AND copy[i] = guess[i] THEN
        result[i] := "green";
        copy[i] := REPR 0
      FI
    OD;
    # then the rest: #
    FOR i TO UPB guess DO
      IF result[i] = "" THEN
        FOR j TO UPB copy DO
          IF copy[j] = guess[i] THEN
            result[i] := "yellow";
            copy[j] := REPR 0;
            next
          FI
        OD;
        result[i] := "grey";
        next: SKIP
      FI
    OD;
    result
  END;

[,]STRING pairs = (("ALLOW", "LOLLY"),
                   ("BULLY", "LOLLY"),
                   ("ROBIN", "ALERT"),
                   ("ROBIN", "SONIC"),
                   ("ROBIN", "ROBIN"));
FOR i TO UPB pairs DO
  print((pairs[i,1], " v ", pairs[i,2], " => ",
         join(wordle comparison(pairs[i,1], pairs[i,2]), ", "),
         newline))
OD
