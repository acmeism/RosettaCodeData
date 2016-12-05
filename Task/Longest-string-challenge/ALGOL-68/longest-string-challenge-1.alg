BEGIN
   INT bound = 1000000;			 CO Arbitrary upper limit on string lengths CO
   INT max;				 CO Length of longest string CO
   INT len;				 CO Length of string under examination CO
   STRING buffer := "";			 CO All characters read from stand in CO
   STRING mask := bound * "0";		 CO High water mark of string length seen so far CO
CO Standard boiler plate CO
   on file end (stand in, (REF FILE f) BOOL: (close (f); GOTO finished));
   DO
      STRING line;
      read ((line, newline));
      buffer PLUSAB line + REPR 10;	CO Concatenate string and newline CO
      mask[UPB line] := "1"		CO And set mask where character exists in line CO
   OD;
finished:
   buffer PLUSAB REPR 10;		CO Guarantee there's a zero-length string at the end CO
CO
   Scan backwards through mask looking for highest index used which is equal to the length
   of the longest string with its terminating newline.
CO
   FOR i FROM bound BY -1 TO 1
   DO
      FROM ABS mask[i] TO ABS "0" DO max := i OD	CO Exploit ABS "1" > ABS "0" CO
   OD;
   FROM 1 TO UPB buffer
   DO							CO Null loop if buffer is empty CO
      VOID (char in string (REPR 10, len, buffer));	CO Pedantry and Algol68 Genie extension CO
      FROM max TO len
      DO						CO Null loop if len < max CO
	 FOR i FROM 1 TO max
	 DO
	    printf (($a$, buffer[i]))			CO Print string and newline CO
	 OD
      OD;
      buffer := buffer[len : UPB buffer];		CO Step over string CO
      buffer := buffer[2 : UPB buffer]			CO Step over newline CO
   OD
END
