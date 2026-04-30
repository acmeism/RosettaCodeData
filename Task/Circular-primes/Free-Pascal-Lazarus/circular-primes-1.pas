program circularprimes;
{$mode objfpc}
  function IsPrime(n: Cardinal): Boolean;inline;
  var
    i, limit: Cardinal;
  begin
    if (n = 2) or (n = 3) then Exit(True);
    if (n <= 1) or (n mod 2 = 0) or (n mod 3 = 0) then Exit(False);

    i := 5;
    limit := Trunc(Sqrt(n));
    while i <= limit do
    begin
      if (n mod i = 0) or (n mod (i + 2) = 0) then Exit(False);
      Inc(i, 6);
    end;
    Result := True;
  end;

  function cycle(const n:Cardinal):Cardinal;inline;
  var
    m:Cardinal;
    p:Cardinal = 1;
  begin
    m := n;
    while m >= 10 do
    begin
        p := p * 10;
        m := m div 10;
    end;
    result := m + 10 * (n mod p);
  end;

  function IsCircularPrime(N: Cardinal): boolean;inline;
  var
    p:Cardinal;
  begin
    p := n;
    repeat
      if not IsPrime(p) or (p<n) then exit(false);
      p := Cycle(p);
    until p = n;
	Result:=True;
  end;

var
  i,c: Cardinal;
  s: string = '';
begin
  c := 0;
  for i := 0 to High(i) do
  if IsPrime(i) then
    if IsCircularPrime(i) then
    begin
     Inc(c);
    writestr(s,s,i:7);
    if c >= 19 then break;
    If c mod 5 = 0 then s:=s+lineEnding;
    end;
  writeln(s,' Count = ',c);
end.
