program SizeOfFile;

{$APPTYPE CONSOLE}

uses SysUtils;

function CheckFileSize(const aFilename: string): Integer;
var
  lFile: file of Byte;
begin
  AssignFile(lFile, aFilename);
  FileMode := 0; {Access file in read only mode}
  Reset(lFile);
  Result := FileSize(lFile);
  CloseFile(lFile);
end;

begin
  Writeln('input.txt ', CheckFileSize('input.txt'));
  Writeln('\input.txt ', CheckFileSize('\input.txt'));
end.
