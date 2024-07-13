function SumBelowDiagonal(a: array [,] of integer): integer;
begin
  var sum := 0;
  for var i:=1 to a.RowCount-1 do
  for var j:=0 to i-1 do
    sum += a[i,j];
  Result := sum;
end;

begin
  var a := MatrGen(5,5,(i,j) -> Random(1,5));
  a.Println;
  Print(SumBelowDiagonal(a));
end.
