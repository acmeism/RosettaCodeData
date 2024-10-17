program Remove_lines_from_a_file_using_TStringList;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes;

// zero started Index
procedure RemoveLines(FileName: TFileName; Index, Line_count: Cardinal);
begin
  if not FileExists(FileName) then
    exit;

  with TStringList.Create do
  begin
    LoadFromFile(FileName);
    for var _ := 1 to Line_count do
    begin
      if Index >= Count then
        Break;
      Delete(Index);
    end;
    SaveToFile(FileName);
    Free;
  end;
end;

begin
  // Remove 2th & 3td line of file
  RemoveLines('input.txt', 1, 2);
end.
