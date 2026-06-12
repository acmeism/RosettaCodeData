uses numlibabc;

function engel(x: fraction): sequence of biginteger;
begin
  result := new list<biginteger>;
  while x.numerator <> 0 do
  begin
    var a := (x.denominator + x.numerator - 1) div x.numerator;
    result := result + a;
    x := x * a - 1;
  end;
end;

function tofraction(s: string): fraction;
begin
  var period := s.IndexOf('.');
  result := Frc(s.Remove(period, 1).ToBigInteger, Power(10bi, s.Length - period - 1));
end;

function fromEngel(engel: sequence of biginteger): decimal;
begin
  var sum: decimal := 0;
  var prod: decimal := 1;
  foreach var e in engel do
  begin
    var r: decimal := decimal(1 / e);
    prod := prod * r;
    sum := sum + prod;
  end;
  result := sum;
end;

begin
  foreach var val in |'3.14159265358979', '2.71828182845904', '1.414213562373095', '7.59375',
  '3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679821480865132823066470938446095505822317253594081284811174502841027019385211',
  '2.71828182845904523536028747135266249775724709369995957496696762772407663035354759457138217852516642743',
  '1.4142135623730950488016887242096980785696718753769480731766797379907324784621070388503875343276415727350138462309122970249248360558507372126441214970999358314132226659275055927558'| do
  begin
    var e := engel(tofraction(val));
    println('Value: ', val);
    println('Engel expansion: ', e.Take(30));
    println('Number of terms: ', e.count);
    println('Back to rational:', fromengel(e));
    println;
  end;
end.
