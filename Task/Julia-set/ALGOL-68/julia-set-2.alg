FOR yi FROM -100 BY 5 TO 100 DO # draw an ASCII art Julia set, translation of Lua #
  REAL y = yi / 100;
  FOR xi FROM -1500 BY 25 TO 1500 DO
    REAL zr := xi / 1000; REAL zi := y; INT i := 0; BOOL again := TRUE;
    WHILE again AND i < 100 DO
      REAL zrp = zr, zip = zi;
      zr := zrp*zrp - zip*zip - 0.79; zi := zrp * zip * 2 + 0.15;
      IF zr*zr + zi*zi > 4 THEN # break # again := FALSE ELSE i +:= 1 FI
    OD;
    print( ( " .:-=+*#%$@"[ 1 + i OVER 10 ] ) )
  OD;
  print( ( newline ) )
OD
