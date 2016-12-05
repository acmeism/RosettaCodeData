PROGRAM magic;
(* Magic squares of odd order *)
CONST
  n=9;
VAR
  i,j :INTEGER;
BEGIN (*magic*)
  WRITELN('The square order is: ',n);
  FOR i:=1 TO n DO
  BEGIN
    FOR j:=1 TO n DO
      WRITE((i*2-j+n-1) MOD n*n + (i*2+j-2) MOD n+1:5);
    WRITELN
  END;
  WRITELN('The magic number is: ',n*(n*n+1) DIV 2)
END (*magic*).
