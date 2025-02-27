uses NumLibABC;

function multipleRegression(y, x: Matrix): Matrix;
begin
  var cy := y.Transpose;
  var cx := x.Transpose;
  result := ((x * cx).Inv * x * cy).Transpose;
end;

begin
  var y := new Matrix(1, 5, 1, 2, 3, 4, 5);
  var x := new Matrix(1, 5, 2, 1, 3, 4, 5);
  multipleRegression(y, x).println(18, 15);

  y := new Matrix(1, 3, 3, 4, 5);
  x := new Matrix(2, 3, 1, 2, 1, 1, 1, 2);
  multipleRegression(y, x).Println(4, 1);

  y := new Matrix(1, 15, 52.21, 53.12, 54.48, 55.84, 57.20, 58.57, 59.93, 61.29,
                         63.11, 64.47, 66.28, 68.10, 69.92, 72.19, 74.46);
  var a := |1.47, 1.5, 1.52, 1.55, 1.57, 1.6, 1.63, 1.65, 1.68, 1.7, 1.73, 1.75, 1.78, 1.8, 1.83|;
  var aa := a.Select(x -> x.Sqr).ToArray;
  var c := |1.0| * a.Length + a + aa;
  x := new Matrix(3, a.Length, c);
  multipleRegression(y, x).Println(18, 12);
end.
