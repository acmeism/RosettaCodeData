function Factors(n: integer): List<integer>;
begin
  var res := HSet(1,n);
  for var i:=2 to n.Sqrt.Trunc do
    if n.Divs(i) then
    begin
      res.Add(i);
      res.Add(n div i);
    end;
  Result := res.Order.ToList;
end;

begin
  foreach var x in |45,53,64| do
    Println(x,Factors(x));
end.
