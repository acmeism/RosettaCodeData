function isqrt(x: biginteger): biginteger;
begin
  var q := 1bi;
  result := 0bi;
  while q <= x do
    q := q shl 2;
  while q > 1 do
  begin
    q := q shr 2;
    var t := x - result - q;
    result := result shr 1;
    if t >= 0 Then
    begin
      x := t;
      result += q;
    end;
  end;
end;

procedure juggler(k: biginteger; countdig: boolean := True);
begin
  var m := k;
  var maxj := k;
  var maxjpos := 0;
  for var i := 1 to 1000 do
  begin
    m := if m mod 2 = 0 then isqrt(m) else isqrt(m * m * m);
    if m >= maxj then
      (maxj, maxjpos) := (m, i);
    if m = 1 then
    begin
      writeln(k:9, i:6, maxjpos:6, ' ', (if countdig then maxj.ToString.Length else maxj):20
              , if countdig then ' digits, ' + milliseconds.ToString + ' ms' else '');
      exit;
    end;
  end;
end;

begin
  writeln('       n    l(n)  i(n)         h(n) or d(n)');
  for var k := 20 to 39 do
    juggler(k, False);

  foreach var k in [113, 173, 193, 2183, 11229, 15065, 15845, 30817] do
    juggler(k)
end.
