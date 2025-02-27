const
  K = 7.8e9;
  N0 = 27;
  Actual =
  |27.0,      27.0,      27.0,      44.0,      44.0,      59.0,      59.0,
  59.0,      59.0,      59.0,      59.0,      59.0,      59.0,      60.0,
  60.0,      61.0,      61.0,      66.0,      83.0,     219.0,     239.0,
  392.0,     534.0,     631.0,     897.0,    1350.0,    2023.0,    2820.0,
  4587.0,    6067.0,    7823.0,    9826.0,   11946.0,   14554.0,   17372.0,
  20615.0,   24522.0,   28273.0,   31491.0,   34933.0,   37552.0,   40540.0,
  43105.0,   45177.0,   60328.0,   64543.0,   67103.0,   69265.0,   71332.0,
  73327.0,   75191.0,   75723.0,   76719.0,   77804.0,   78812.0,   79339.0,
  80132.0,   80995.0,   82101.0,   83365.0,   85203.0,   87024.0,   89068.0,
  90664.0,   93077.0,   95316.0,   98172.0,  102133.0,  105824.0,  109695.0,
  114232.0,  118610.0,  125497.0,  133852.0,  143227.0,  151367.0,  167418.0,
  180096.0,  194836.0,  213150.0,  242364.0,  271106.0,  305117.0,  338133.0,
  377918.0,  416845.0,  468049.0,  527767.0,  591704.0,  656866.0,  715353.0,
  777796.0,  851308.0,  928436.0, 1000249.0, 1082054.0, 1174652.0|;

function f(r: real): real;
begin
  foreach var i in (0..Actual.length - 1) do
  begin
    var eri := exp(r * i);
    var guess := (N0 * eri) / (1 + N0 * (eri - 1) / K);
    var diff := guess - Actual[i];
    result += diff * diff;
  end;
end;

function solve(fn: (real) -> real; guess: real := 0.5; epsilon: real := 0.0): real;
begin
  result := guess;
  var delta := if result <> 0 then result else 1.0;
  var f0 := fn(result);
  var factor := 2.0;

  while (delta > epsilon) and (result <> result - delta) do
  begin
    var nf := fn(result - delta);
    if nf < f0 then
    begin
      f0 := nf;
      result -= delta;
    end
    else
      nf := fn(result + delta);
    if nf < f0 then
    begin
      f0 := nf;
      result += delta;
    end
    else
      factor := 0.5;
    delta *= factor;
  end;
end;

begin
  var r := solve(f);
  var r0 := exp(12 * r);
  writeln('r = ', r, ', R0 = ', r0);
end.
