program RenameFile;

{$APPTYPE CONSOLE}

uses SysUtils;

begin
  SysUtils.RenameFile('input.txt', 'output.txt');
  SysUtils.RenameFile('\input.txt', '\output.txt');

  // RenameFile works for both files and folders
  SysUtils.RenameFile('docs', 'MyDocs');
  SysUtils.RenameFile('\docs', '\MyDocs');
end.
