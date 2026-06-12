program Special_Divisors;
{$IFDEF FPC}
  {$MODE DELPHI}
 uses
    SysUtils,
    StrUtils;
{$ELSE}
  {$APPTYPE CONSOLE}
 uses
    System.SysUtils,
    System.StrUtils;
{$ENDIF}

const
  limit1 = 200;

var
  row, num, revNum, revDiv: Integer;
  flag: boolean;

procedure Main();
var
  n,m: NativeUint;
begin
  writeln('Working...'#10);
  row := 0;
  num := 0;

  for n := 1 to limit1 do
  begin
    flag := True;
    revNum := reversestring(n.ToString).ToInteger;
    for m := 1 to n div 2 do
    begin
      revDiv := reversestring(m.ToString).ToInteger;
      if n mod m = 0 then
        if revNum mod revDiv = 0 then
          flag := True
        else
        begin
          flag := False;
          Break;
        end;
    end;

    if flag then
    begin
      inc(num);
      inc(row);
      write(n: 4);
      if row mod 10 = 0 then
        Writeln;
    end;
  end;

  writeln(#10#10'Found ', num,
    ' special divisors N that reverse(D) divides reverse(N) for all divisors D of N, where  N  <  200');

  writeln('Done...');
end;

begin
  Main;
 {$IFNDEF UNIX} readln; {$ENDIF}
end.
