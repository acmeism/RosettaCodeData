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

function isMagnanimous(n: int64): boolean;
begin
  var p := 10;
  result := True;
  while True do
  begin
    var a := n div p;
    var b := n mod p;
    if a = 0 then exit;
    if not isPrime(a + b) then break;
    p *= 10;
  end;
  result := false;
end;

function magnanimous(): sequence of int64;
begin
  var n: int64 := 0;
  while true do
  begin
    if isMagnanimous(n) then yield n;
    n += 1;
  end;
end;

begin
  writeln('First 45 magnanimous numbers:');
  magnanimous.Take(45).Println;
  writeln(#10, '241st through 250th magnanimous numbers:');
  magnanimous.Skip(240).Take(10).Println;
  writeln(#10, '391st through 400th magnanimous numbers:');
  magnanimous.Skip(390).Take(10).Println;
end.
