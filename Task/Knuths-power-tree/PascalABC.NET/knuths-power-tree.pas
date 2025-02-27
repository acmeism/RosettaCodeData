uses NumLibABC;

var
  p := Dict((1, 0));
  lvl := Lst(Lst(word(1)));

function tofraction(s: string): fraction;
begin
  var period := s.IndexOf('.');
  if period = -1 then result := Frc(s.ToBigInteger)
  else result := Frc(s.Remove(period, 1).ToBigInteger, Power(10bi, s.Length - period - 1));
end;

function path(n: word): List<word>;
begin
  result := new List<word>;
  if n = 0 then exit;
  while not p.ContainsKey(n) do
  begin
    var q := new List<word>;
    foreach var x in lvl[0] do
      foreach var y in path(x) do
      begin
        if (x + y) in p then break;
        p[x + y] := x;
        q.add(x + y);
      end;
    lvl[0] := q;
  end;
  result := path(p[n]) + Lst(n);
end;

function treePow(x: real; n: word): Fraction;
begin
  var frac := tofraction(FloatToStr(x));
  var r := Dict((0, Frc(1)), (1, frac));
  var p := 0;
  foreach var i in path(n) do
  begin
    r[i] := r[i - p] * r[p];
    p := i;
  end;
  result := r[n];
end;

procedure showPow(x: real; n: word);
begin
  writeln(n, ': ', path(n));
  writeln(x, '^', n, ' = ', treePow(x, n), #10);
end;

begin
  for var n := 0 to 17 do showPow(2, n);
  showPow(1.1, 81);
  showPow(3, 191);
end.
