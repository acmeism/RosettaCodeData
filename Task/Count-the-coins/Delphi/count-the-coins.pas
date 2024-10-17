program Count_the_coins;

{$APPTYPE CONSOLE}

function Count(c: array of Integer; m, n: Integer): Integer;
var
  table: array of Integer;
  i, j: Integer;
begin
  SetLength(table, n + 1);
  table[0] := 1;
  for i := 0 to m - 1 do
    for j := c[i] to n do
      table[j] := table[j] + table[j - c[i]];
  Exit(table[n]);
end;

var
  c: array of Integer;
  m, n: Integer;

begin
  c := [1, 5, 10, 25];

  m := Length(c);
  n := 100;
  Writeln(Count(c, m, n));  //242
  Readln;
end.
