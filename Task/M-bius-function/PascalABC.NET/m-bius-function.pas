uses school;

function mobius(n: integer): integer;
begin
  var factors := n.Factorize;
  if factors.Count = factors.ToSet.Count then
    result := if factors.Count.IsEven then 1 else -1
  else result := 0
end;

begin
  println('Mobius numbers from 1..99:');
  for var n := 1 to 99 do
    write(mobius(n):3, if n mod 20 = 0 then #10 else '');
end.
