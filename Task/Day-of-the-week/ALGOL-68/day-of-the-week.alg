# example from: http://www.xs4all.nl/~jmvdveer/algol.html - GPL #
INT sun=0 # , mon=1, tue=2, wed=3, thu=4, fri=5, sat=6 #;

PROC day of week = (INT year, month, day) INT: (
  # Day of the week by Zeller’s Congruence algorithm from 1887 #
  INT y := year, m := month, d := day, c;
  IF m <= 2 THEN
    m +:= 12; y -:= 1
  FI;
  c := y OVER 100;
  y %*:= 100;
  (d - 1 + ((m + 1) * 26) OVER 10 + y + y OVER 4 + c OVER 4 - 2 * c) MOD 7
);

test:(
  print("December 25th is a Sunday in:");
  FOR year FROM 2008 TO 2121 DO
    INT wd = day of week(year, 12, 25);
    IF wd = sun THEN print(whole(year,-5)) FI
  OD;
  new line(stand out)
)
