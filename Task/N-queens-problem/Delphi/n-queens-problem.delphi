program N_queens_problem;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

var
  i: Integer;
  q: boolean;
  a: array[0..8] of boolean;
  b: array[0..16] of boolean;
  c: array[0..14] of boolean;
  x: array[0..8] of Integer;

procedure TryMove(i: Integer);
begin
  var j := 1;
  while True do
  begin
    q := false;
    if a[j] and b[i + j] and c[i - j + 7] then
    begin
      x[i] := j;
      a[j] := false;
      b[i + j] := false;
      c[i - j + 7] := false;

      if i < 8 then
      begin
        TryMove(i + 1);
        if not q then
        begin
          a[j] := true;
          b[i + j] := true;
          c[i - j + 7] := true;
        end;
      end
      else
        q := true;
    end;
    if q or (j = 8) then
      Break;
    inc(j);
  end;
end;

begin
  for i := 1 to 8 do
    a[i] := true;

  for i := 2 to 16 do
    b[i] := true;

  for i := 0 to 14 do
    c[i] := true;

  TryMove(1);

  if q then
    for i := 1 to 8 do
      writeln(i, ' ', x[i]);
  readln;
end.
