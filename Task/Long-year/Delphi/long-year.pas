program Long_year;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

function p(const Year: Integer): Integer;
begin
  Result := (Year + (Year div 4) - (Year div 100) + (Year div 400)) mod 7;
end;

function IsLongYear(const Year: Integer): Boolean;
begin
  Result := (p(Year) = 4) or (p(Year - 1) = 3);
end;

procedure PrintLongYears(const StartYear: Integer; const EndYear: Integer);
var
  Year, Count: Integer;
begin
  Count := 0;
  for Year := 1800 to 2100 do
    if IsLongYear(Year) then
    begin
      if Count mod 10 = 0 then
        Writeln;
      Write(Year, ' ');
      inc(Count);
    end;
end;

var
  Year: Integer;

begin
  Writeln('Long years between 1800 and 2100:');
  PrintLongYears(1800, 2100);
  Readln;
end.
