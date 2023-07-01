program Perfect_totient_numbers;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

function totient(n: Integer): Integer;
begin
  var tot := n;
  var i := 2;
  while i * i <= n do
  begin
    if (n mod i) = 0 then
    begin
      while (n mod i) = 0 do
        n := n div i;
      dec(tot, tot div i);
    end;
    if i = 2 then
      i := 1;
    inc(i, 2);
  end;
  if n > 1 then
    dec(tot, tot div n);
  Result := tot;
end;

begin
  var perfect: TArray<Integer>;
  var n := 1;
  while length(perfect) < 20 do
  begin
    var tot := n;
    var sum := 0;
    while tot <> 1 do
    begin
      tot := totient(tot);
      inc(sum, tot);
    end;
    if sum = n then
    begin
      SetLength(perfect, Length(perfect) + 1);
      perfect[High(perfect)] := n;
    end;
    inc(n, 2);
  end;
  writeln('The first 20 perfect totient numbers are:');
  write('[');
  for var e in perfect do
    write(e, ' ');
  writeln(']');
  readln;
end.
