program LoopsNPlusOneHalf;

{$APPTYPE CONSOLE}

var
  i: integer;
const
  MAXVAL = 10;
begin
  for i := 1 to MAXVAL do
  begin
    Write(i);
    if i < MAXVAL then
      Write(', ');
  end;
  Writeln;
end.
