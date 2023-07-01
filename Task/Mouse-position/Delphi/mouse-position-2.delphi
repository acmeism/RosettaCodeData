program Project1;
{$APPTYPE CONSOLE}
uses
  SysUtils, Controls, Windows;

var
  MyMouse : TMouse;
begin
  MyMouse := TMouse.Create;
  While True do
  begin
    WriteLn('(X, y) = (' + inttostr(TPoint(MyMouse.CursorPos).x) + ',' + inttostr(TPoint(MyMouse.CursorPos).y) + ')');
    sleep(300);
  end
end.
