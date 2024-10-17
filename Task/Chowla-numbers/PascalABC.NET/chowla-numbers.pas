function chowla(n: Integer): Integer;
begin
  result := 0;
  var i := 2;
  while i * i <= n do
  begin
    if n mod i = 0 then
      result += i + (if i = n div i then 0 else n div i);
    i += 1
  end;
end;

function sieve(limit: Integer): array of Boolean;
begin
  result := new Boolean[limit];
  for var i := 3 to limit div 3 step 2 do
    if not result[i] and (chowla(i) = 0) Then
      for var j := 3 * i to limit step 2 * i do
        result[j] := true;
end;

begin
  for var i := 1 To 37 do
    WriteLn('chowla(', i, ') = ', chowla(i));

  var count := 1;
  var limit := 10_000_000;
  var power := 100;
  var c := sieve(limit);
  for var i := 3 To limit Step 2 do
  begin
    if not c[i] Then count += 1;
    if i = power - 1 Then begin
      WriteLn('Count of primes up to ', power:8, ' = ', count);
      power *= 10;
    end;
  end;

  count := 0;
  limit := 35_000_000;
  var k := 2; var kk := 3;
  while True do
  begin
    var p := k * kk;
    if p > limit Then break;
    if chowla(p) = p - 1 Then begin
      WriteLn(p:8, ' is a number that is perfect');
      count += 1;
    end;
    k := kk + 1;
    kk += k;
  end;
  WriteLn('There are ', count, ' perfect numbers <= 35,000,000')
end.
