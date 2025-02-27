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

begin
  var a1: Matrix := ((1, 2), (3, 4));
  var b1: Matrix := ((0, 5), (6, 7));
  kronecker(a1, b1).Println;
  println;
  var a2: Matrix := ((0, 1, 0), (1, 1, 1), (0, 1, 0));
  var b2: Matrix := ((1, 1, 1, 1), (1, 0, 0, 1), (1, 1, 1, 1));
  kronecker(a2, b2).Println;
end.
