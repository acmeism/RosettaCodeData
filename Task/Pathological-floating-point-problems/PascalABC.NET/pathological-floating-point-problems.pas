uses numlibabc;

function muller_seq(n: integer): real;
begin
  var seq := Lst(Frc(0), Frc(2), Frc(-4));
  foreach var i in range(3, n + 1) do
  begin
    var next_value := 111 - 1130 / seq[i - 1] + 3000 / (seq[i - 1] * seq[i - 2]);
    seq.Add(next_value);
  end;
  result := seq[n].ToReal
end;

function tofraction(s: string): Fraction;
begin
  var period := s.IndexOf('.');
  result := Frc(s.Remove(period, 1).ToBigInteger, Power(10bi, s.Length - period - 1));
end;

function bank(years: integer): real;
const
  e = '2.71828182845904523536028747135266249775724709369995';
begin
  var bigE := ToFraction(e);
  var balance := bigE - 1;
  for var year := 1 to years do
    balance := balance * year - 1;
  result := balance.ToReal;
end;

function rump(a, b: biginteger): real;
begin
  var f := ToFraction('333.75') * b ** 6
  + a ** 2 * (11 * a ** 2 * b ** 2 - b ** 6 - 121 * b ** 4 - 2)
  + ToFraction('5.5') * b ** 8 + Frc(a, 2 * b);
  result := f.ToReal;
end;

begin
  println('Task 1:');
  foreach var n in [3, 4, 5, 6, 7, 8, 20, 30, 50, 100] do
    println(n, muller_seq(n));
  println('Task 2: ', bank(25));
  println('Task 3: ', rump(77617, 33096));
end.
