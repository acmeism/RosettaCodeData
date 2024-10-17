function GCD(a, b: integer): integer;
begin
  while b > 0 do
    (a, b) := (b, a mod b);
  Result := a;
end;

function ModularMultiplicativeInverse(a, m: integer): integer;
begin
  var b := a Mod m;
  for var x := 1 To m - 1 do
    if (b * x) Mod m = 1 Then begin Result := x; exit end;
  Result := 1;
end;

procedure Solve(n, a: array of integer);
begin
  var coprime := 1;
  foreach var (i, j) in n.combinations(2) do coprime *= GCD(i, j);
  if coprime <> 1 then
  begin println('Not pairwise co-prime'); exit end;

  var prod := n.Aggregate(1, (i, j)-> i * j);
  var sm := 0;
  for var i := 0 To n.Length - 1 do
  begin
    var p := prod div n[i];
    sm += a[i] * ModularMultiplicativeInverse(p, n[i]) * p;
  end;
  var result := sm Mod prod;

  for var counter := 0 to n.Length - 1 do
    WriteLn($'{result} = {a[counter]} (mod {n[counter]})');
end;

begin
  solve(|3, 5, 7|, |2, 3, 2|);
  solve(|10, 4, 9|, |11, 22, 19|);
  solve(|11, 12, 13|, |10, 4, 12|);
  solve(|5, 7, 9, 11|, |1, 2, 3, 4|);
end.
