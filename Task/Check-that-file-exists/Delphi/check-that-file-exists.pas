program EnsureFileExists;

{$APPTYPE CONSOLE}

uses
  SysUtils;

begin
  if FileExists('input.txt') then
    Writeln('File "input.txt" exists.')
  else
    Writeln('File "input.txt" does not exist.');

  if FileExists('\input.txt') then
    Writeln('File "\input.txt" exists.')
  else
    Writeln('File "\input.txt" does not exist.');

  if DirectoryExists('docs') then
    Writeln('Directory "docs" exists.')
  else
    Writeln('Directory "docs" does not exists.');

  if DirectoryExists('\docs') then
    Writeln('Directory "\docs" exists.')
  else
    Writeln('Directory "\docs" does not exists.');
end.
