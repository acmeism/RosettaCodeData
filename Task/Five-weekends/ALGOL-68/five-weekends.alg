five_weekends: BEGIN
  INT m, year, nfives := 0, not5 := 0;
  BOOL no5weekend;

  MODE MONTH = STRUCT(
    INT n,
    [3]CHAR name
  ) # MODE MONTH #;

  []MONTH month = (
    MONTH(13, "Jan"),
    MONTH(3,  "Mar"),
    MONTH(5,  "May"),
    MONTH(7,  "Jul"),
    MONTH(8,  "Aug"),
    MONTH(10, "Oct"),
    MONTH(12, "Dec")
  );

  FOR year FROM 1900 TO 2100 DO
    IF year = 1905 THEN printf($"..."l$) FI;
    no5weekend := TRUE;
    FOR m TO UPB month DO
      IF n OF month(m) = 13 THEN
        IF day_of_week(1, n OF month(m), year-1) = 6 THEN
          IF year<1905 OR year > 2096 THEN printf(($g, 5zl$, name OF month(m), year)) FI;
          nfives +:= 1;
          no5weekend := FALSE
        FI
      ELSE
        IF day_of_week(1, n OF month(m), year) = 6 THEN
          IF year<1905 OR year > 2096 THEN printf(($g, 5zl$, name OF month(m), year)) FI;
          nfives +:= 1;
          no5weekend := FALSE
        FI
      FI
    OD;
    IF no5weekend THEN not5 +:= 1 FI
  OD;

  printf(($g, g(0)l$, "Number of months with five weekends between 1900 and 2100 = ", nfives));
  printf(($g, g(0)l$, "Number of years between 1900 and 2100 with no five weekend months = ", not5));

# contains #

  PROC day_of_week = (INT d, m, y)INT: BEGIN
    INT j, k;
    j := y OVER 100;
    k := y MOD 100;
    (d + (m+1)*26 OVER 10 + k + k OVER 4 + j OVER 4 + 5*j) MOD 7
  END # function day_of_week #;
  SKIP
END # program five_weekends #
