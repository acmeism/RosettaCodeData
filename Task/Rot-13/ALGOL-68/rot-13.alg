BEGIN
  CHAR c;
  on logical file end(stand in, (REF FILE f)BOOL: (stop; SKIP));
  on line end(stand in, (REF FILE f)BOOL: (print(new line); FALSE));
  DO
    read(c);
    IF c >= "A" AND c <= "M" OR c >= "a" AND c <= "m" THEN
      c := REPR(ABS c + 13)
    ELIF c >= "N" AND c <= "Z" OR c >= "n" AND c <= "z" THEN
      c := REPR(ABS c - 13)
    FI;
    print(c)
  OD
END # rot13 #
