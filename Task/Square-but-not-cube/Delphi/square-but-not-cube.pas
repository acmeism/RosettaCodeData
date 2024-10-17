program Square_but_not_cube;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Math;

begin
  var count := 0;
  var n := 1;
  while count < 30 do
  begin
    var sq := n * n;
    var cr := Trunc(Power(sq, 1 / 3));
    if cr * cr * cr <> sq then
    begin
      inc(count);
      writeln(sq);
    end
    else
      Writeln(sq, ' is square and cube');
    inc(n);
  end;

 {$IFNDEF UNIX}   readln; {$ENDIF}
end.
