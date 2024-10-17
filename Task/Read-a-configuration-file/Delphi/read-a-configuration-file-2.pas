program ReadAConfigFile;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  uSettings;

const
  FileName = 'Config.txt';

var
  Settings: TSettings;

procedure show(key: string; value: string);
begin
  writeln(format('%14s = %s', [key, value]));
end;

begin
  Settings := TSettings.Create;
  Settings.LoadFromFile(FileName);

  for var k in Settings.Keys do
    show(k, Settings[k]);

  Settings.Free;
  Readln;
end.
