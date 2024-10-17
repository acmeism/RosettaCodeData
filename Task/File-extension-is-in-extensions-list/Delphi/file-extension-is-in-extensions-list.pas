program File_extension_is_in_extensions_list;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

const
  exts: TArray<string> = ['zip', 'rar', '7z', 'gz', 'archive', 'A##', 'tar.bz2'];
  filenames: TArray<string> = ['MyData.a##', 'MyData.tar.Gz', 'MyData.gzip',
    'MyData.7z.backup', 'MyData...', 'MyData', 'MyData_v1.0.tar.bz2', 'MyData_v1.0.bz2'];

begin
  write('extensions: [');
  for var ext in exts do
  begin
    write(ext, ' ');
  end;
  writeln(']'#10);

  for var filename in filenames do
  begin
    var found := false;
    for var ext in exts do
      if (filename.toLower.endsWith('.' + ext.toLower)) then
      begin
        found := True;
        Break;
      end;
    writeln(filename: 20, ' : ', found);
  end;

  readln;
end.
