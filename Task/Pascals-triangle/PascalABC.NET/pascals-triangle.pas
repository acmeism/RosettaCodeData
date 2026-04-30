procedure Pascal(r: Integer);
var
  triangle: array of array of Integer; // Зубчатый массив

begin
  SetLength(triangle, r);
  for var i := 0 to r - 1 do
  begin
    SetLength(triangle[i], i + 1);
    triangle[i][0] := 1;
    triangle[i][i] := 1;

    if i > 1 then
      for var j := 1 to i - 1 do
        triangle[i][j] := triangle[i - 1][j - 1] + triangle[i - 1][j];
  end;

  for var i := 0 to r - 1 do
  begin
    write(StringOfChar(' ', (r - i) * 2));
    for var j := 0 to i do
      write(triangle[i][j]:4);
    writeln;
  end;
end;
begin
  Pascal(13); // Генерация треугольника Паскаля
end.
