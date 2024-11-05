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

function Factorial(n: integer): int64;
begin
  Result := 1;
  for var i := 2 to n do Result *= i;
end;

begin
  var found := 0;
  var i := 1;
  while found < 10 do
  begin
    var fact := Factorial(i);
    if IsPrime(fact - 1) then
    begin
      writeln(i:2, '! - 1 = ', fact - 1);
      found += 1;
    end;
    if IsPrime(fact + 1) then
    begin
      writeln(i:2, '! + 1 = ', fact + 1);
      found += 1;
    end;
    i += 1;
  end;
end.
