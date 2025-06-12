uses school;

function totient(n: int64) := (1..n).Select(k -> (if gcd(n, k) = 1 then 1 else 0)).Sum;

function perfect(): sequence of integer;
begin
  var n := 1;
  repeat
    var tot := n;
    var sum := 0;
    while tot <> 1 do
    begin
      tot := totient(tot);
      sum += tot;
    end;
    if sum = n then yield n;
    n += 2;
  until false;
end;

begin
  perfect.Take(20).Println;
end.
