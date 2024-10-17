program TestLeapYear;

{$APPTYPE CONSOLE}

uses
  SysUtils;

var
  Year: Integer;

begin
  Write('Enter the year: ');
  Readln(Year);
  if IsLeapYear(Year) then
    Writeln(Year, ' is a Leap year')
  else
    Writeln(Year, ' is not a Leap year');
  Readln;
end.
