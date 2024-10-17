##
uses numlibabc;

function combos(sides: array of integer; n: integer): array of biginteger;
begin
  if n = 0 then
  begin
    result := |1bi|;
    exit
  end;
  result := arrfill(sides.Max * n + 1, 0bi);
  foreach var v in combos(sides, n - 1) index i do
  begin
    if v = 0 then continue;
    foreach var s in sides do
      result[i + s] += v;
  end;
end;

procedure winning(sides1: array of integer; n1: integer; sides2: array of integer; n2: integer);
begin
  var p1 := combos(sides1, n1);
  var p2 := combos(sides2, n2);
  var (win, loss, tie) := (0bi, 0bi, 0bi);
  foreach var x1 in p1 index i do
  begin
    win += x1 * (p2?[:i]).sum;
    tie += x1 * (p2?[i:i + 1]).sum;
    loss += x1 * (p2?[i + 1:]).sum;
  end;
  var s := p1.Sum * p2.Sum;
  var winrat := Frc(win, s);
  var tierat := Frc(tie, s);
  var lossrat := Frc(loss, s);
  println('P1 win: ', winrat.ToReal, winrat);
  println('tie   : ', tierat.ToReal, tierat);
  println('P2 win: ', lossrat.ToReal, lossrat);
  println;
end;

winning(arr(1..4), 9, arr(1..6), 6);
winning(arr(1..10), 5, arr(1..7), 6);
//winning(|1, 2, 3, 5, 9|, 700, |1, 2, 3, 4, 5, 6|, 800);
