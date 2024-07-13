label 1;

begin
  var a: array [,] of integer := MatrRandomInteger(3,4,1,10);
  a.Println;

  var found := False;
  for var i:=0 to a.RowCount-1 do
  for var j:=0 to a.ColCount-1 do
    if a[i,j] = 5 then
    begin
      found := True;
      goto 1;
    end;
  1: Println(found);
end.
