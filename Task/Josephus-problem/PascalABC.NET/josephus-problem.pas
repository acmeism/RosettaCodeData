procedure j(n, k: integer);
begin
  var p := (0..n - 1).ToList;
  var i := 0;
  var s := new List<integer>;

  while p.Count > 0 do
  begin
    i := (i + k - 1) mod p.Count;
    s.Add(p[i]);
    p.RemoveAt(i);
  end;

  println('Prisoner killing order:', s.SkipLast);
  println('Survivor:', s.Last);
end;

begin
  j(5, 2);
  j(41, 3);
end.
