program Cantor_set;

{$APPTYPE CONSOLE}

const
  WIDTH: Integer = 81;
  HEIGHT: Integer = 5;

var
  Lines: TArray<TArray<Char>>;

procedure Init;
var
  i, j: Integer;
begin
  SetLength(lines, HEIGHT, WIDTH);
  for i := 0 to HEIGHT - 1 do
    for j := 0 to WIDTH - 1 do
      lines[i, j] := '*';
end;

procedure Cantor(start, len, index: Integer);
var
  seg, i, j: Integer;
begin
  seg := len div 3;
  if seg = 0 then
    Exit;
  for i := index to HEIGHT - 1 do
    for j := start + seg to start + seg * 2 - 1 do
      lines[i, j] := ' ';
  Cantor(start, seg, index + 1);
  Cantor(start + seg * 2, seg, index + 1);
end;

var
  i, j: Integer;

begin
  Init;
  Cantor(0, WIDTH, 1);
  for i := 0 to HEIGHT - 1 do
  begin
    for j := 0 to WIDTH - 1 do
      Write(lines[i, j]);
    Writeln;
  end;
  Readln;
end.
