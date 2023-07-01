program Tau_number;

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
  Writeln('The first 100 tau numbers are:');
  var count := 0;
  var i := 1;
  while count < 100 do
  begin
    var tf := CountDivisors(i);
    if i mod tf = 0 then
    begin
      write(format('%4d ', [i]));
      inc(count);
      if count mod 10 = 0 then
        writeln;
    end;
    inc(i);
  end;

  {$IFNDEF UNIX}  readln; {$ENDIF}
end.
