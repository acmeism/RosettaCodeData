program Power_set;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

const
  n = 4;

var
  buf: TArray<Integer>;

procedure rec(ind, bg: Integer);
begin
  for var i := bg to n - 1 do
  begin
    buf[ind] := i;
    for var j := 0 to ind do
      write(buf[j]: 2);
    writeln;
    rec(ind + 1, buf[ind] + 1);
  end;
end;

begin
  SetLength(buf, n);
  rec(0,0);
  {$IFNDEF UNIX}readln;{$ENDIF}
end.
