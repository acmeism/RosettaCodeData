procedure Output(params arr: array of object);
begin
  foreach var obj in arr do
    Println(obj);
end;

begin
  Output(1,2.5,'z','PascalABC.NET');
  var a: array of object := (1,2.5,'z','PascalABC.NET');
  Output(a);
end.
