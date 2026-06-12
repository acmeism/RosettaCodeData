function digitsum(n: biginteger) :=
    n.ToString.select(x -> StrToInt(x)).sum;

procedure expDigitSums(numNeeded, minWays, maxPower: integer);
begin
  var i := 1bi;
  var c := 0;
  while (c < numNeeded) do
  begin
    i += 1;
    var n := i;
    var res: sequence of string := new List<string>;
    for var p :=  2 to maxPower do
    begin
      n *= i;
      var ds := digitSum(n);
      if i = ds then res := res + |' ',i.tostring, '^', p.tostring|.jointostring('');

      if (p > 10) and (i * 2 < ds) then break
    end;
    if (res.Count >= minWays) then
    begin
      println(res);
      c += 1;
    end;
  end;
end;

begin
  println('First twenty-five integers that are equal to the digital sum of that integer raised to some power:');
  expDigitSums(25, 1, 100);
  println;
  println('First thirty that satisfy that condition in three or more ways:');
  expDigitSums(30, 3, 500);
end.
