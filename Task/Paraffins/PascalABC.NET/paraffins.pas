const
  nMax = 250;
  nBranches = 4;

var
  rooted := (0..nMax).Select(n -> 0bi).ToArray;
  unrooted := (0..nMax).Select(n -> 0bi).ToArray;

function choose(m: biginteger; k: integer): biginteger;
begin
  result := m;
  if k = 1 then exit
  else
    for var i := 1 to k - 1 do
      result := result * (m + i) div (i + 1)
end;

procedure tree(br, n, l, sum: integer; cnt: biginteger);
begin
  var s := 0;
  foreach var b in (br + 1.. nBranches) do
  begin
    s := sum + (b - br) * n;
    if s > nMax then exit;

    var c := choose(rooted[n], b - br) * cnt;

    if l * 2 < s then unrooted[s] += c;
    if b = nBranches then exit;
    rooted[s] += c;
    for var m := n - 1 downto 1 do
      tree(b, m, l, s, c);
  end;
end;

procedure bicenter(s: integer);
begin
  if (s and 1) = 0 then
    unrooted[s] += rooted[s div 2] * (rooted[s div 2] + 1) div 2;
end;

begin
  (rooted[0], rooted[1], unrooted[0], unrooted[1]) := (1bi, 1bi, 1bi, 1bi);
  for var n := 1 to nMax do
  begin
    tree(0, n, n, 1, 1bi);
    bicenter(n);
    writeln(n, ': ', unrooted[n]);
  end;
end.
