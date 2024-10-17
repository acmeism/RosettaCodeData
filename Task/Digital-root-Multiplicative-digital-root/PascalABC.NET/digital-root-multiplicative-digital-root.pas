##
function MulDigitalRoot(num: int64): (integer, integer);
begin
  var mulpersistence := 0;
  while num > 9 do
  begin
    num := num.ToString.ToCharArray.Select(x -> x.ToDigit).Aggregate((x, y) -> x * y);
    mulpersistence += 1;
  end;
  result := (mulpersistence, integer(num));
end;

var nums := |123321, 7739, 893, 899998|;
foreach var num in nums do
begin
  var t := MulDigitalRoot(num);
  Writeln(num, ' has multiplicative persistence ', t[0], ' and multiplicative digital root ', t[1])
end;

var twidth := 5;
var table := new List<int64>[10];
for var i := 0 to 9 do
  table[i] := new List<int64>();
var number := -1;
while (table.Any(x -> x.Count < twidth)) do
begin
  number += 1;
  var t := MulDigitalRoot(number);
  if (table[t[1]].Count < twidth) then
    table[t[1]].Add(number);
end;
for var i := 0 to 9 do
  WriteLn(i, ' : [', string.Join(', ', table[i]), ']');
