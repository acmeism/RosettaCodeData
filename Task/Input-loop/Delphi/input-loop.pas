program InputLoop;

{$APPTYPE CONSOLE}

uses SysUtils, Classes;

var
  lReader: TStreamReader; // Introduced in Delphi XE
begin
  lReader := TStreamReader.Create('input.txt', TEncoding.Default);
  try
    while lReader.Peek >= 0 do
      Writeln(lReader.ReadLine);
  finally
    lReader.Free;
  end;
end.
