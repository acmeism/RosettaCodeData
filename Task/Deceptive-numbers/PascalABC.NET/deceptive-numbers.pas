uses School;

function Deceptives(num: integer): List<integer>;
begin
  Result := new List<integer>;
  var n := 2;
  var r:BigInteger := 1;
  while Result.Count < num do
  begin
    if not n.IsPrime and (r mod n = 0) then
      Result.Add(n);
    n += 1;
    r := 10*r + 1;
  end;
end;

begin
  Deceptives(25).Println;
end.
