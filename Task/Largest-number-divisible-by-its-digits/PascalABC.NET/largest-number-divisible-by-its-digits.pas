function digits(n: int64; base: byte): List<byte>;
begin
  result := new List<byte>;
  repeat
    result.Add(byte(n mod base));
    n := n div base;
  until n = 0;
end;

function isLynchBell(num: int64; base: byte) := digits(num, base).All(x -> num mod x = 0);

begin
  for var n := 9876432 downto 1 do
  begin
    var dignum := digits(n, 10);
    if (dignum.Count = dignum.ToSet.Count) and (not dignum.Contains(0)) then
      if islynchbell(n, 10) then
      begin
        Println('Largest decimal number is:', n);
        break;
      end;
  end;

  var magic := 15 * 14 * 13 * 12 * 11;
  var n := $fedcba987654321 div magic * magic;
  while n > 0 do
  begin
    var dignum := digits(n, 16);
    if (dignum.Count = dignum.ToSet.Count) and (not dignum.Contains(0)) then
      if islynchbell(n, 16) then
      begin
        Println('Largest hex number is:', n.ToString('x'));
        break;
      end;
    n -= magic;
  end;
end.
