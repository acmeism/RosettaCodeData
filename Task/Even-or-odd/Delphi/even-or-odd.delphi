program EvenOdd;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

procedure IsOdd(aValue: Integer);
var
  Odd: Boolean;
begin
  Odd :=  aValue and 1 <> 0;
  Write(Format('%d is ', [aValue]));
  if Odd then
    Writeln('odd')
  else
    Writeln('even');
end;

var
  i: Integer;
begin
  for i := -5 to 10 do
    IsOdd(i);

  Readln;
end.
