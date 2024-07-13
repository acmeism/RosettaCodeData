begin
  var (m,n) := ReadInteger2;
  var a: array[,] of integer := new integer[m,n];
  a[0,0] := 1; a[m-1,n-1] := 55;
  a.Println;
  var a1 := MatrRandomInteger(m,n);
  a1.Println;
end.
