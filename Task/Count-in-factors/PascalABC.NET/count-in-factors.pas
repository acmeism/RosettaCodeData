// https://rosettacode.org/wiki/Count_in_factors#PascalABC.NET

function Factorize(x: integer): List<integer>;
begin
  Result := new List<integer>;
  if x = 1 then
  begin
    Result.Add(1);
    exit
  end;
  var i := 2;
  repeat
    if x.Divs(i) then
    begin
      Result.Add(i);
      x := x div i;
    end
    else i += 1;
  until x = 1;
end;

begin
  var n := 22;
  (1..n).PrintLines(x -> $'{x,3}: {Factorize(x).JoinToString('' * '')}')
end.
