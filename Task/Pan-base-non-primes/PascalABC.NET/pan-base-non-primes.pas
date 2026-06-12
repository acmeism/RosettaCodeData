function isPrime(n: int64): boolean;
const
  Wheel = |4, 2, 4, 2, 4, 6, 2, 6|;
begin
  if n < 2 then result := false
  else if (n and 1) = 0 then result := n = 2
  else if n mod 3 = 0 then result := n = 3
  else if n mod 5 = 0 then result := n = 5
  else begin
    var p: int64 := 7;
    while True do
      foreach var w in Wheel do
      begin
        if p * p > n then begin result := true; exit end
        else if n mod p = 0 then begin result := false; exit end
        else p += w
      end;
  end;
end;

function Digits(n: int64): list<byte>;
begin
  result := new List<byte>;
  while n <> 0 do
  begin
    result.add(n mod 10);
    n := n div 10
  end;
end;

function fromDigits(a: list<byte>; base: integer): int64;
begin
  for var i := a.Count - 1 downto 0 do
    result := result * base + a[i];
end;

function isPanBaseNonPrime(n: int64): boolean;
begin
  result := True;
  if n < 10 then begin result := not isPrime(n); exit end;
  if (n > 10) and (n mod 10 = 0) then exit;
  var d := Digits(n);
  var maxDigit := d.Max;
  foreach var base in (maxDigit + 1..n) do
    if isPrime(fromDigits(d, base)) then
      result := False;
end;

begin
  println('First 50 prime pan-base composites:');
  2.Step.Where(n -> isPanBaseNonPrime(n)).Take(50).println;
  println;
  println('First 20 odd prime pan-base composites:');
  3.Step(2).Where(n -> isPanBaseNonPrime(n)).Take(20).println;
  println;
  var panbase := (2..2500).Where(n -> isPanBaseNonPrime(n)).ToList;
  println('Count of pan-base composites up to and including 2500:', panbase.Count);
  var odd_panbase := panbase.Where(n -> n.isodd).ToList;
  writeln('Percent odd up to and including 2500: ', 100 * odd_panbase.count / panbase.Count:2:2);
  writeln('Percent even up to and including 2500: ', 100 - 100 * odd_panbase.count / panbase.Count:2:2);
end.
