program Extract_file_extension;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Character;

const
  TEST_CASES: array[0..5] of string = ('http://example.com/download.tar.gz',
    'CharacterModel.3DS', '.desktop', 'document', 'document.txt_backup',
    '/etc/pam.d/login');

function GetExt(path: string): string;
var
  c: char;
begin
  // Built-in functionality, just extract substring after dot char
  Result := ExtractFileExt(path);

  // Fix ext for dot in subdir
  while (Result.IndexOf('/') > -1) do
  begin
    Result := Result.Substring(Result.IndexOf('/'), MaxInt);
    Result := ExtractFileExt(Result);
  end;

  // Ignore empty or "." ext
  if length(result) < 2 then
    exit('');

  // Ignore ext with not alphanumeric char (except the first dot)
  for var i := 2 to length(result) do
  begin
    c := result[i];
    if not c.IsLetterOrDigit then
      exit('');
  end;
end;

begin
  for var path in TEST_CASES do
    Writeln(path.PadRight(40), GetExt(path));

  {$IFNDEF UNIX} readln; {$ENDIF}
end.
