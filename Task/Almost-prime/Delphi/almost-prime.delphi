program AlmostPrime;

{$APPTYPE CONSOLE}

function IsKPrime(const n, k: Integer): Boolean;
var
  p, f, v: Integer;
begin
  f := 0;
  p := 2;
  v := n;
  while (f < k) and (p*p <= n) do begin
    while (v mod p) = 0 do begin
      v := v div p;
      Inc(f);
    end;
    Inc(p);
  end;
  if v > 1 then Inc(f);
  Result := f = k;
end;

var
  i, c, k: Integer;

begin
  for k := 1 to 5 do begin
    Write('k = ', k, ':');
    c := 0;
    i := 2;
    while c < 10 do begin
      if IsKPrime(i, k) then begin
        Write(' ', i);
        Inc(c);
      end;
      Inc(i);
    end;
    WriteLn;
  end;
end.
