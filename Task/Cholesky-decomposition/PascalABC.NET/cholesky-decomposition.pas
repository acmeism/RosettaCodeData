function Cholesky(a: array of real): array of real;
begin
  var n := Round(Sqrt(a.Length));
  Result := new real[n * n];
  for var i := 0 to n - 1 do
  begin
    for var j := 0 to i do
    begin
      var s := 0.0;
      for var k := 0 to j - 1 do
        s += Result[i * n + k] * Result[j * n + k];
      if i = j then
        Result[i * n + j] := Sqrt(a[i * n + i] - s)
      else Result[i * n + j] := 1 / Result[j * n + j] * (a[i * n + j] - s);
    end;
  end;
end;

procedure ShowMatrix(a: array of real);
begin
  var n := Round(Sqrt(a.Length));
  for var i := 0 to n - 1 do
  begin
    for var j := 0 to n - 1 do
      write(a[i * n + j]:10:5);
    PrintLn('');
  end;
end;

begin
  var m1 := new real[9];
  m1 := |25.0, 15.0, -5.0,
         15.0, 18.0,  0.0,
         -5.0,  0.0, 11.0 |;
  var c1 := Cholesky(m1);
  ShowMatrix(m1);
  println('=>');
  ShowMatrix(c1);

  PrintLn('');

  var m2: array of real :=
  |18.0, 22.0,  54.0,  42.0,
  22.0, 70.0,  86.0,  62.0,
  54.0, 86.0, 174.0, 134.0,
  42.0, 62.0, 134.0, 106.0 |;
  var c2 := Cholesky(m2);
  Showmatrix(m2);
  println('=>');
  ShowMatrix(c2);
end.
