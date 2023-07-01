program Tau_function;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

function CountDivisors(n: Integer): Integer;
begin
  Result := 0;
  var i := 1;
  var k := 2;
  if (n mod 2) = 0 then
    k := 1;

  while i * i <= n do
  begin
    if (n mod i) = 0 then
    begin
      inc(Result);
      var j := n div i;
      if j <> i then
        inc(Result);
    end;
    inc(i, k);
  end;
end;

begin
  writeln('The tau functions for the first 100 positive integers are:');
  for var i := 1 to 100 do
  begin
    write(CountDivisors(i): 2, ' ');
    if (i mod 20) = 0 then
      writeln;
  end;
  readln;
end.
