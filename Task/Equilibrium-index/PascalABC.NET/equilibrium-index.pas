##
function eqindex2Pass(data: array of integer): sequence of integer;
begin
  var (suml, sumr, ddelayed) := (0, data.sum, 0);
  foreach var d in data index i do
  begin
    suml += ddelayed;
    sumr -= d;
    ddelayed := d;
    if suml = sumr then
      yield i
  end;
end;

var d := ||-7, 1, 5, 2, -4, 3, 0|, |2, 4, 6|, |2, 9, 2|, |1, -1, 1, -1, 1, -1, 1||;

foreach var data in d do
  println('d =', data, '->', eqindex2pass(data));
