program Strange_plus_numbers;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

function IsPrime(n: Integer): Boolean;
begin
  Result := n in [2, 3, 5, 7, 11, 13, 17];
end;

begin
  var count := 0;
  var d: TArray<Integer>;
  writeln('Strange plus numbers in the open interval (100, 500) are:');
  for var i := 101 to 499 do
  begin
    d := [];

    var j := i;
    while j > 0 do
    begin
      SetLength(d, Length(d) + 1);
      d[High(d)] := j mod 10;
      j := j div 10;
    end;

    if IsPrime(d[0] + d[1]) and IsPrime(d[1] + d[2]) then
    begin
      write(i, ' ');
      inc(count);
      if count mod 10 = 0 then
        writeln;
    end;
  end;

  if (count mod 10) <> 0 then
    writeln;

  writeln(#10, count, ' strange plus numbers in all.');
  readln;
end.
