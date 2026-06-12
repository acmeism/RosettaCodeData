program TAC;
{$IFDEF FPC}
  {$MODE DELPHI}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils, classes;
var
  Sl:TStringList;
  i,j : nativeInt;
begin
  Sl := TStringList.Create;
  Sl.Loadfromfile('Rodgers.txt');
  i := 0;
  j := Sl.Count-1;
  While i<j do
  Begin
    Sl.Exchange(i,j);
    inc(i);
    dec(j);
  end;
  writeln(Sl.text);
end.
