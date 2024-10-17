program LoopWithStep;

{$APPTYPE CONSOLE}

var
  i: Integer;
begin
  i:=2;
  while i <= 8 do begin
    WriteLn(i);
    Inc(i, 2);
  end;
end.
