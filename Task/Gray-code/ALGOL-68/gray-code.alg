BEGIN
   OP GRAY = (BITS b) BITS : b XOR (b SHR 1);	CO Convert to Gray code CO
   OP YARG = (BITS g) BITS :			CO Convert from Gray code CO
   BEGIN
      BITS b := g, mask := g SHR 1;
      WHILE mask /= 2r0 DO b := b XOR mask; mask := mask SHR 1 OD;
      b
   END;
   FOR i FROM 0 TO 31 DO
      printf (($zd, ": ", 2(2r5d, " >= "), 2r5dl$, i, BIN i, GRAY BIN i, YARG GRAY BIN i))
   OD
END
