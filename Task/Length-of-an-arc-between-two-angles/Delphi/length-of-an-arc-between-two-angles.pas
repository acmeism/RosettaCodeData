program Length_of_an_arc;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

function arc_length(radius, angle1, angle2: Double): Double;
begin
  Result := (360 - abs(angle2 - angle1)) * PI / 180 * radius;
end;

begin
  Writeln(Format('%.7f', [arc_length(10, 10, 120)]));
  Readln;
end.
