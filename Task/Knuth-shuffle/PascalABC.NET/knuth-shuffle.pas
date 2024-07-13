procedure Shuffle<T>(a: array of T);
begin
  for var i := a.Length - 1 downto 1 do
    Swap(a[i], a[Random(i + 1)]);
end;

begin
  var a := Arr(1..9);
  Shuffle(a);
  a.Print;
end.
