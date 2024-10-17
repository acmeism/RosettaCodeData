program ReadAll;

{$APPTYPE CONSOLE}

uses
  SysUtils, IOUtils;

begin
// with default encoding:
  Writeln(TFile.ReadAllText('C:\autoexec.bat'));
// with encoding specified:
  Writeln(TFile.ReadAllText('C:\autoexec.bat', TEncoding.ASCII));
  Readln;
end.
