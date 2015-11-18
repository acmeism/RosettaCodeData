[0:255]BITS crc_table;
BOOL crc_table_computed := FALSE;

PROC make_crc_table = VOID:
   BEGIN
      INT n, k;
      FOR n FROM 0 TO 255 DO
         BITS c := BIN n;
         FOR k TO 8 DO
            c := IF 32 ELEM c THEN
                    16redb88320 XOR (c SHR 1)
                 ELSE
                    c SHR 1
		 FI
	 OD;
	 crc_table[n] := c
      OD;
      crc_table_computed := TRUE
   END;

PROC update_crc = (BITS crc, STRING buf) BITS:
   BEGIN
      BITS c := crc XOR 16rffffffff;
      INT n;

      IF NOT crc_table_computed THEN make_crc_table FI;
      FOR n TO UPB buf DO
         c := crc_table[ABS ((c XOR BIN ABS buf[n]) AND 16rff)] XOR (c SHR 8)
      OD ;
      c XOR 16rffffffff
   END;

 PROC hex = (BITS x) STRING :
   BEGIN
      PROC hexdig = (BITS x) CHAR: REPR (IF ABS x ≤ 9 THEN ABS x + ABS "0"
                                         ELSE ABS x - 10 + ABS "a"
					 FI);
      STRING h := "";
      IF x = 16r0 THEN
	 h := "0"
      ELSE
	 BITS n := x;
	 WHILE h := hexdig (n AND 16rf) + h; n ≠ 16r0 DO
	    n := n SHR 4
	 OD
      FI;
      h
   END;

PROC crc = (STRING buf) BITS:
   update_crc(16r0, buf);

STRING s = "The quick brown fox jumps over the lazy dog";
print(("CRC32 OF ", s, " is: ", hex (crc (s)), newline))
