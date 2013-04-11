MODULE DoorsOpt;
IMPORT InOut;

TYPE State = (Closed, Open);
TYPE List = ARRAY [1 .. 100] OF State;

VAR
  Doors: List;
  I:  CARDINAL;

BEGIN
  FOR I := 1 TO 10 DO
    Doors[I*I] := Open
  END;

  FOR I := 1 TO 100 DO
    InOut.WriteCard(I, 3);
    InOut.WriteString(' is ');
    IF Doors[I] = Closed THEN
      InOut.WriteString('Closed.')
    ELSE
      InOut.WriteString('Open.')
    END;
    InOut.WriteLn
  END
END DoorsOpt.
