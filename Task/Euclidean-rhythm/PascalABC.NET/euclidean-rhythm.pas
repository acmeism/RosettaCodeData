##
function E(k, n: integer): string;
begin
  var s := (1..n).Select(i -> (if i <= k then |'1'| else |'0'|)).ToArray;
  var d := n - k;
  n := Max(k, d);
  k := Min(k, d);
  var z := d;

  while (z > 0) or (k > 1) do
  begin
    for var i := 0 to k - 1 do
      s[i] := s[i] + s[s.Length - i - 1];
    s := s[0:s.Length - k];
    z := z - k;
    d := n - k;
    n := Max(k, d);
    k := Min(k, d);
  end;
  result := s.SelectMany(x -> x).JoinToString;
end;

E(5, 13).Println;
E(3, 8).Println;
