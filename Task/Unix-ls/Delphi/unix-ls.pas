program LsCommand;

{$APPTYPE CONSOLE}



uses
  System.SysUtils,
  System.IoUtils;

procedure Ls(folder: string = '.');
var
  offset: Integer;
  fileName: string;

  // simulate unix results in windows

  function ToUnix(path: string): string;
  begin
    Result := path.Replace('/', PathDelim, [rfReplaceAll])
  end;

begin
  folder := IncludeTrailingPathDelimiter(ToUnix(folder));
  offset := length(folder);

  for fileName in TDirectory.GetFileSystemEntries(folder, '*') do
    writeln(^I, ToUnix(fileName).Substring(offset));
end;

begin
  writeln('cd foo'#10'ls');
  ls('foo');

  writeln(#10'cd bar'#10'ls');
  ls('foo/bar');

  {$IFNDEF LINUX} readln; {$ENDIF}
end.
