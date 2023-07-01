MODULE DoorsOpt EXPORTS Main;

IMPORT IO, Fmt;

TYPE State = {Closed, Open};
TYPE List = ARRAY [1..100] OF State;

VAR doors := List{State.Closed, ..};

BEGIN
  FOR i := 1 TO 10 DO
    doors[i * i] := State.Open;
  END;

  FOR i := FIRST(doors) TO LAST(doors) DO
    IO.Put(Fmt.Int(i) & " is ");
    IF doors[i] = State.Closed THEN
      IO.Put("Closed.\n");
    ELSE
      IO.Put("Open.\n");
    END;
  END;
END DoorsOpt.
