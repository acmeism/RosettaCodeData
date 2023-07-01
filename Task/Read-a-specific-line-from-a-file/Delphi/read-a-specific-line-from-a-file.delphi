program Read_a_specific_line_from_a_file;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

function ReadLine(position: Cardinal; FileName: TFileName): string;
begin
  Result := '';

  if not FileExists(FileName) then
    raise Exception.Create('Error: File does not exist.');

  var F: TextFile;
  var line: string;
  AssignFile(F, FileName);
  Reset(F);
  for var _ := 1 to position do
  begin
    if Eof(F) then
    begin
      CloseFile(F);

      raise Exception.Create(Format('Error: The file "%s" is too short. Cannot read line %d',
        [FileName, position]));
    end;

    Readln(F, line);
  end;
  CloseFile(F);
  Result := line;
end;

begin
  Writeln(ReadLine(7, 'test'));
  Readln;
end.
