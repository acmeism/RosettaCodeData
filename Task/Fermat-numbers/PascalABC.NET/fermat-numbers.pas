##
function IsPrime(n: biginteger): boolean;
begin
  if (n = 2) or (n = 3) then Result := true
  else if (n <= 1) or ((n mod 2) = 0) or ((n mod 3) = 0) then Result := false
  else
  begin
    var i := 5bi;
    Result := False;
    while i * i < n do
    begin
      if (n mod i) = 0 then
      begin
        println(i, n div i);
        exit;
      end
      else if (n mod (i + 2)) = 0 then
      begin
        println(i + 2, n div (i + 2));
        exit;
      end;
      i += 6;
    end;
    Result := True;
  end;
end;

function fermat(n: integer) := power(2bi, int64(power(2, n))) + 1;

for var n := 0 to 9 do writeln('F', n, ' = ', fermat(n));
for var n := 0 to 6 do
begin
  write('F', n, ' = ');
  if isprime(fermat(n)) then println(fermat(n));
end;
