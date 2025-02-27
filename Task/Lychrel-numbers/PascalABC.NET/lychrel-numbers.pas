const
  iterations = 1000;
  limit = 10_000;

var
  cache := new Dictionary<biginteger, (boolean, biginteger)>;

function rev(n: biginteger) := n.ToString[::-1].ToBigInteger;

function lychrel(n: biginteger): (boolean, biginteger);
begin
  if n in cache then result := cache[n]
  else begin
    var r := rev(n);
    var res := (True, n);
    var seen := new List<biginteger>;
    loop iterations do
    begin
      n += r;
      r := rev(n);
      if n = r then
      begin
        res := (False, 0bi);
        break
      end;
      if n in cache then
      begin
        res := cache[n];
        break
      end;
      seen.Add(n)
    end;

    foreach var x in seen do cache[x] := res;
    result := res;
  end;
end;

begin
  var seeds := new List<integer>;
  var related := new List<integer>;
  var palin := new List<integer>;

  foreach var i in (1..limit) do
  begin
    var (tf, s) := lychrel(i);
    if not tf then continue;
    if i = s then seeds.Add(i) else related.Add(i);
    if i = rev(i) then palin.Add(i);
  end;

  println('There are', seeds.count, 'Lychrel seeds, namely:', seeds);
  println('Lychrel related numbers:', related.count);
  println('There are', palin.count, 'Lychrel palindromes, namely:', palin);
end.
