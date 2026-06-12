uses School;

function IsPerfectSquare(x: integer): boolean;
var r := Round(Sqrt(x));
begin
  exit(r*r = x);
end;

begin
  var limit := 16000;
  var q := 2;
  Print(q);

  while true do
  begin
    var found := false;
    var p := q + 1;
    while p < limit do
    begin
      if IsPrime(p) and IsPerfectSquare(p - q) then
      begin
        Print(p);
        q := p;
        found := true;
        break;
      end;
      p += 1;
    end;
    if not found then break;
  end;
end.

