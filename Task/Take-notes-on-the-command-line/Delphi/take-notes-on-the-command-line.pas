program notes;

{$APPTYPE CONSOLE}

uses
  Classes,
  SysUtils,
  IOUtils;

const
  FILENAME = 'NOTES.TXT';
  TAB = #9;

var
  sw: TStreamWriter;
  i : integer;

begin
  if ParamCount = 0 then
  begin
    if TFile.Exists(FILENAME) then
      write(TFile.ReadAllText(FILENAME));
  end
  else
  begin
    if TFile.Exists(FILENAME) then
      sw := TFile.AppendText(FILENAME)
    else
      sw := TFile.CreateText(FILENAME);

    sw.Write(FormatDateTime('yyyy-mm-dd hh:nn',Now));
    sw.Write(TAB);
    for i := 1 to ParamCount do
    begin
      sw.Write(ParamStr(i));
      if i < ParamCount then
        sw.Write(' ');
    end;
    sw.WriteLine;
    sw.Free;
  end;
end.
