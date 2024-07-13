procedure SortThree(var x,y,z: integer);
begin
  if x > y then Swap(x, y);
  if x > z then Swap(x, z);
  if y > z then Swap(y, z);
end;

begin
  var (x,y,z) := Random3(1,10);
  Println(x,y,z);
  SortThree(x,y,z);
  Assert((x <= y) and (y <= z));
  Println(x,y,z);
end.
