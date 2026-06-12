program Sum_of_divisors;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

function DivisorSum(n: Cardinal): Cardinal;
var
  total, power, p, sum: Cardinal;
begin
  total := 1;
  power := 2;

  // Deal with powers of 2 first

  while (n and 1 = 0) do
  begin
    inc(total, power);
    power := power shl 1;
    n := n shr 1;
  end;

  // Odd prime factors up to the square root
  p := 3;
  while p * p <= n do
  begin
    sum := 1;
    power := p;
    while n mod p = 0 do
    begin
      inc(sum, power);
      power := power * p;
      n := n div p;
    end;
    total := total * sum;
    inc(p, 2);
  end;

  // If n > 1 then it's prime
  if n > 1 then
    total := total * (n + 1);
  Result := total;
end;

begin
  const limit = 100;
  writeln('Sum of divisors for the first ', limit, ' positive integers:');
  for var n := 1 to limit do
  begin
    Write(divisorSum(n): 8);
    if n mod 10 = 0 then
      writeln;
  end;

 {$IFNDEF UNIX} readln; {$ENDIF}
end.
