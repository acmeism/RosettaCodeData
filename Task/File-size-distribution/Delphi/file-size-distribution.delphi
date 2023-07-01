program File_size_distribution;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Math,
  Winapi.Windows;

function Commatize(n: Int64): string;
begin
  result := n.ToString;
  if n < 0 then
    delete(result, 1, 1);
  var le := result.Length;
  var i := le - 3;
  while i >= 1 do
  begin
    Insert(',', result, i + 1);
    dec(i, 3);
  end;

  if n >= 0 then
    exit;

  Result := '-' + result;
end;

procedure Walk(Root: string; walkFunc: TProc<string, TWin32FindData>); overload;
var
  rec: TWin32FindData;
  h: THandle;
  directory, PatternName: string;
begin
  if not Assigned(walkFunc) then
    exit;

  Root := IncludeTrailingPathDelimiter(Root);

  h := FindFirstFile(Pchar(Root + '*.*'), rec);
  if (INVALID_HANDLE_VALUE <> h) then
    repeat
      if rec.cFileName[0] = '.' then
        Continue;
      walkFunc(directory, rec);
      if ((rec.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) =
        FILE_ATTRIBUTE_DIRECTORY) and (rec.cFileName[0] <> '.') then
        Walk(Root + rec.cFileName, walkFunc);
    until not FindNextFile(h, rec);
  FindClose(h);
end;

procedure FileSizeDistribution(root: string);
var
  sizes: TArray<Integer>;
  files, directories, totalSize, size, i: UInt64;
  c: string;
begin
  SetLength(sizes, 12);
  files := 0;
  directories := 0;
  totalSize := 0;
  size := 0;

  Walk(root,
    procedure(path: string; info: TWin32FindData)
    var
      logSize: Extended;
      index: integer;
    begin
      inc(files);
      if (info.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) =
        FILE_ATTRIBUTE_DIRECTORY then
        inc(directories);
      size := info.nFileSizeHigh shl 32 + info.nFileSizeLow;
      if size = 0 then
      begin
        sizes[0] := sizes[0] + 1;
        exit;
      end;

      inc(totalSize, size);
      logSize := Log10(size);
      index := Floor(logSize);
      sizes[index] := sizes[index] + 1;
    end);

  writeln('File size distribution for "', root, '" :-'#10);
  for i := 0 to High(sizes) do
  begin
    if i = 0 then
      write('  ')
    else
      write('+ ');
    writeln(format('Files less than 10 ^ %-2d bytes : %5d', [i, sizes[i]]));
  end;
  writeln('                                  -----');
  writeln('= Total number of files         : ', files: 5);
  writeln('  including directories         : ', directories: 5);
  c := commatize(totalSize);
  writeln(#10'  Total size of files           : ', c, 'bytes');
end;

begin
  fileSizeDistribution('.');
  readln;
end.
