program Secure_temporary_file;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.IOUtils;

var
  FileName, buf: string;

begin
  FileName := TPath.GetTempFileName;
  with TFile.Open(FileName, TFileMode.fmCreate, TFileAccess.faReadWrite,
    Tfileshare.fsNone) do
  begin
    buf := 'This is a exclusive temp file';
    Write(buf[1], buf.Length * sizeof(char));
    Free;
  end;

  writeln(FileName);
  Readln;
end.
