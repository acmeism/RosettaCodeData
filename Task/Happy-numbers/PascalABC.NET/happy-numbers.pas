uses School;

function IsHappy(n: integer): boolean;
begin
  Result := False;
  var cache := new HashSet<integer>;
  while n <> 1 do
  begin
    if n in cache then
      exit;
    cache.Add(n);
    n := n.Digits.Sum(d -> d*d);
  end;
  Result := True;
end;

begin
  var n := 1;
  var happyNums := new List<integer>;
  while happyNums.Count < 8 do
  begin
    if IsHappy(n) then
      happyNums.Add(n);
    n += 1;
  end;
  happyNums.Print
end.
