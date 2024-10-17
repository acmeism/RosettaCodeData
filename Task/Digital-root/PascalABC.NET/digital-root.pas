##
function DigitalRoot(num: int64): (integer, integer);
begin
  var additivepersistence := 0;
  while num > 9 do
  begin
    num := num.ToString.ToCharArray.Sum(x -> x.ToDigit);
    additivepersistence += 1;
  end;
  result := (additivepersistence, integer(num));
end;

var nums := |627615, 39390, 588225, 393900588225|;
foreach var num in nums do
begin
  var t := DigitalRoot(num);
  Writeln(num, ' has additive persistence ', t[0], ' and digital root ', t[1])
end;
