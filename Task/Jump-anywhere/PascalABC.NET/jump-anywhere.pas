label finish;

begin
  var a := MatrRandomInteger(3,4);
  var found := False;
  for var i:=0 to a.RowCount-1 do
  for var j:=0 to a.ColCount-1 do
    if a[i,j] = 10 then
    begin
      found := True;
      goto finish;
    end;
finish:
  Print(found);
end.
