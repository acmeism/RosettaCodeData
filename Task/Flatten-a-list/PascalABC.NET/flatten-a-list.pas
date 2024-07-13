function Flatten(lst: List<object>): List<object>;
begin
  Result := new List<object>;
  foreach var x in lst do
    if x is List<object> then
      Result.Addrange(Flatten(x as List<object>))
    else Result.Add(x)
end;

function LstObj(params a: array of object): List<Object> := new List<Object>(a);

begin
  var lst := LstObj(1,LstObj(2, LstObj(3,4), LstObj(5,6)), LstObj(LstObj(7,8), 9));
  Println(lst);
  Println(Flatten(lst));
end.
