PROC specific characters = ([]STRING ss) []INT:
  BEGIN
    PROC count and erase = (REF STRING s, CHAR ch) INT:
      BEGIN
        INT count := 0, pos;
        WHILE char in string(ch, pos, s) DO
          count +:= 1;
          s[pos] := REPR 0
        OD;
        count
      END;

    [UPB ss]INT result;

    FOR i TO UPB ss DO
      result[i] := 0;
      STRING s := ss[i];
      FOR j TO UPB s - 1 DO
        CHAR ch = s[j];
        IF ch /= REPR 0 THEN
          INT count = count and erase(s, ch);
          IF count = 2 THEN
            BOOL unique := TRUE;
            FOR k TO UPB ss DO
              IF k /= i THEN
                unique := unique AND ~char in string(ch, LOC INT, ss[k])
              FI
             OD;
             IF unique THEN result[i] +:= 1 FI
           FI
         FI
       OD
     OD;
     result
   END;

print((specific characters(("ahwiueshaiu", "ajxxfioaaf", "ajrdsfroiwr")), new line))
