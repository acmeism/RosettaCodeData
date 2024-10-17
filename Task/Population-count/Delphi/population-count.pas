program Population_count;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Math;

function PopulationCount(AInt: UInt64): Integer;
begin
  Result := 0;
  repeat
    inc(Result, (AInt and 1));
    AInt := AInt div 2;
  until (AInt = 0);
end;

var
  i, count: Integer;
  n: Double;
  popCount: Integer;

begin
  Writeln('Population Counts:'#10);
  Write('3^n :   ');
  for i := 0 to 30 do
  begin
    n := Math.Power(3, i);
    popCount := PopulationCount(round(n));
    Write(Format('%d ', [popCount]));
  end;
  Writeln(#10#10'Evil:   ');

  count := 0;
  i := 0;
  while (count < 30) do
  begin
    popCount := PopulationCount(i);
    if not Odd(popCount) then
    begin
      inc(count);
      Write(Format('%d ', [i]));
    end;
    inc(i);
  end;
  Writeln(#10#10'Odious: ');

  count := 0;
  i := 0;
  while (count < 30) do
  begin
    popCount := PopulationCount(i);
    if Odd(popCount) then
    begin
      inc(count);
      Write(Format('%d ', [i]));
    end;
    inc(i);
  end;

  readln;
end.
