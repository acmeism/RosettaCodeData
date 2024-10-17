function IsGapful(n: integer): boolean;
begin
  var first := n.ToString[1].ToDigit;
  var num := first * 10 + n mod 10;
  Result := n.Divs(num);
end;

function FindGapful(from,n: integer): List<integer>;
begin
  Result := new List<integer>;
  var i := from;
  while Result.Count < n do
  begin
    if IsGapful(i) then
      Result.Add(i);
    i += 1
  end;
end;

begin
  Println('First 30 gapful numbers starting at 100:');
  FindGapful(100,30).Println;
  Println('First 15 gapful numbers starting at 1,000,000:');
  FindGapful(1000000,15).Println;
  Println('First 10 gapful numbers starting at 1,000,000,000:');
  FindGapful(1000000000,10).Println;
end.
