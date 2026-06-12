function IsPrime(n: int64): boolean;
begin
  if (n = 2) or (n = 3) then Result := true
  else if (n <= 1) or ((n mod 2) = 0) or ((n mod 3) = 0) then Result := false
  else
  begin
    var i := 5;
    Result := False;
    while i <= trunc(sqrt(n)) do
    begin
      if ((n mod i) = 0) or ((n mod (i + 2)) = 0) then exit;
      i += 6;
    end;
    Result := True;
  end;
end;

function powMod(a, n, m: int64): int64;
begin
  a := a mod m;
  if a > 0 then
  begin
    result := 1;
    while n > 0 do
    begin
      if (n and 1) <> 0 then
        result := (result * a) mod m;
      n := n shr 1;
      a := (a * a) mod m;
    end;
  end;
end;

function isFermatPseudoprime(x, a: integer): boolean;
begin
  if isPrime(x) then result := false
  else result := powMod(a, x - 1, x) = 1
end;

begin
  for var a := 1 to 20 do
  begin
    var count := 0;
    var first20 := new List<integer>;
    for var x := 1 to 50_000 do
      if isFermatPseudoprime(x, a) then
      begin
        count += 1;
        if count <= 20 then first20.add(x)
      end;
    println('Base', a, ':');
    println('  Number of Fermat pseudoprimes up to 50_000:', count);
    println('  First 20:', first20);
  end;
end.
