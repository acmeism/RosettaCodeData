##
uses numlibabc;

function tofraction(s: string): fraction;
begin
  var period := s.IndexOf('.');
  result := Frc(s.Remove(period, 1).ToBigInteger, Power(10bi, s.Length - period - 1));
end;

var decimals := |0.9054054, 0.518518, 0.75|;
foreach var dec in decimals do
begin
  print(dec.ToString,'->');
  println(tofraction(dec.tostring));
end;
