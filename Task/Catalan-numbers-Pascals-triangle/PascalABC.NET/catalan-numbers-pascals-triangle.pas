const
  n = 15;

begin
  var t: array[0..n + 1] of integer;
  t[1] := 1;
  for var i := 1 to n do
  begin
    for var j := i downto 1 do t[j] += t[j - 1];
    t[i + 1] := t[i];
    for var j := i + 1 downto 1 do t[j] += t[j - 1];
    print(t[i + 1] - t[i]);
  end;
end.
