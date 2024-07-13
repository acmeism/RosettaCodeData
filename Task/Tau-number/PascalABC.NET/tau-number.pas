##
function DivisorsCount(n: integer) := Range(1,n).Count(i -> n.Divs(i));

var lst := new List<integer>;
var n := 1;
while lst.Count < 100 do
begin
  if n.Divs(DivisorsCount(n)) then
    lst.Add(n);
  n += 1;
end;
lst.Println;
