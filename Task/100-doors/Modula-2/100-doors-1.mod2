MODULE Doors;
IMPORT InOut;

TYPE State = (Closed, Open);
TYPE List = ARRAY [1 .. 100] OF State;

VAR
  Doors: List;
  I, J:  CARDINAL;

BEGIN
  FOR I := 1 TO 100 DO
    FOR J := 1 TO 100 DO
      IF J MOD I = 0 THEN
        IF Doors[J] = Closed THEN
          Doors[J] := Open
        ELSE
          Doors[J] := Closed
        END
      END
    END
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
END Doors.
