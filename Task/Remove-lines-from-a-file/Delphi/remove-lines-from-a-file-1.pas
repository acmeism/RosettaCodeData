program Remove_lines_from_a_file_using_TStringDynArray;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.IoUtils;

// zero started Index
procedure RemoveLines(FileName: TFileName; Index, Line_count: Cardinal);
begin
  if not FileExists(FileName) then
    exit;

  var lines := TFile.ReadAllLines(FileName);

  Delete(lines, Index, Line_count);
  TFile.WriteAllLines(FileName, lines);
end;

begin
  // Remove 2th & 3td line of file
  RemoveLines('input.txt', 1, 2);
end.
