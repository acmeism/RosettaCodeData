program SierpinskiCarpet;

uses
  Math;

function In_carpet(a, b: longint): boolean;
var
  x, y: longint;
begin
  x := a;
  y := b;
  while true do
  begin
    if (x = 0) or (y = 0) then
    begin
      In_carpet := true;
      break;
    end
    else if ((x mod 3) = 1) and ((y mod 3) = 1) then
    begin
      In_carpet := false;
      break;
    end;
    x := x div 3;
    y := y div 3;
  end;
end;

procedure Carpet(n: integer);
var
  i, j, limit: longint;
begin
{$IFDEF FPC}
  limit := 3 *  * n - 1;
{$ELSE}
  limit := Trunc(IntPower(3, n) - 1);
{$ENDIF}

  for i := 0 to limit do
  begin
    for j := 0 to limit do
      if In_carpet(i, j) then
        write('*')
      else
        write(' ');
    writeln;
  end;
end;

begin
  Carpet(3);
  {$IFNDEF UNIX}      readln; {$ENDIF}
end.
