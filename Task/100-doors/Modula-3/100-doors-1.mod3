MODULE Doors EXPORTS Main;

IMPORT IO, Fmt;

TYPE State = {Closed, Open};
TYPE List = ARRAY [1..100] OF State;

VAR doors := List{State.Closed, ..};

BEGIN
  FOR i := 1 TO 100 DO
    FOR j := FIRST(doors) TO LAST(doors) DO
      IF j MOD i = 0 THEN
        IF doors[j] = State.Closed THEN
          doors[j] := State.Open;
        ELSE
          doors[j] := State.Closed;
        END;
      END;
    END;
  END;

  FOR i := FIRST(doors) TO LAST(doors) DO
    IO.Put(Fmt.Int(i) & " is ");
    IF doors[i] = State.Closed THEN
      IO.Put("Closed.\n");
    ELSE
      IO.Put("Open.\n");
    END;
  END;
END Doors.
