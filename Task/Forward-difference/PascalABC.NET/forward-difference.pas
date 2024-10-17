function Convert(a: array of integer): array of integer;
begin
  var n := a.Length;
  var res := new integer[n-1];
  for var i:=0 to n-2 do
    res[i] := a[i+1]-a[i];
  Result := res;
end;

begin
  var a := |90, 47, 58, 29, 22, 32, 55, 5, 55, 73|;
  while a.Length > 0 do
  begin
    Println(a);
    a := Convert(a);
  end;
end.
