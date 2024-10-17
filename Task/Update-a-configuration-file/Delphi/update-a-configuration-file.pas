program uConfigFile;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  uSettings;

const
  FileName = 'uConf.txt';

var
  Settings: TSettings;

procedure show(key: string; value: string);
begin
  writeln(format('%14s = %s', [key, value]));
end;

begin
  Settings := TSettings.Create;
  Settings.LoadFromFile(FileName);
  Settings['NEEDSPEELING'] := False;
  Settings['SEEDSREMOVED'] := True;
  Settings['NUMBEROFBANANAS'] := 1024;
  Settings['numberofstrawberries'] := 62000;

  for var k in Settings.Keys do
    show(k, Settings[k]);
  Settings.SaveToFile(FileName);
  Settings.Free;
  Readln;
end.
