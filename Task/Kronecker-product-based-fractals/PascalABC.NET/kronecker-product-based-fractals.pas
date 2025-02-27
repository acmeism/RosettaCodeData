type
  Matrix = array [,] of integer;

function kronecker(a, b: Matrix): Matrix;
begin
  SetLength(result, a.RowCount * b.RowCount, a.ColCount * b.ColCount);
  for var i := 0 to a.RowCount - 1 do
    for var j := 0 to a.ColCount - 1 do
      for var k := 0 to b.RowCount - 1 do
        for var l := 0 to b.ColCount - 1 do
          result[b.RowCount * i + k, b.ColCount * j + l] := a[i, j] * b[k, l];
end;

function kroneckerPower(m: Matrix; n: integer): Matrix;
begin
  result := Copy(m);
  foreach var i in 2..n do
    result := kronecker(result, m)
end;

procedure printMatrix(text: String; m: Matrix);
begin
  println(text, 'fractal :');
  for var i := 0 to m.RowCount - 1 do
  begin
    for var j := 0 to m.ColCount - 1 do
      write(if (m[i, j] = 1) then '*' else ' ');
    println();
  end;
  println();
end;

begin
  var a: Matrix := ((0, 1, 0), (1, 1, 1), (0, 1, 0));
  printMatrix('Vicsek', kroneckerPower(a, 4));

  var b: Matrix := ((1, 1, 1), (1, 0, 1), (1, 1, 1));
  printMatrix('Sierpinski carpet', kroneckerPower(b, 4))
end.
