procedure FloydTriangle(rows: integer);
begin
  var r := 1;
  for var i:=1 to rows do
  begin
    for var j:=1 to i do
    begin
      Write(r: (j>8 ? 4 : 3));
      r += 1;
    end;
    Writeln
  end;
end;

begin
  FloydTriangle(5);
  Writeln;
  FloydTriangle(14);
end.
