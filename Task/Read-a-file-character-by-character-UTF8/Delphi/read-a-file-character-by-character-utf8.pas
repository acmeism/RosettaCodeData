program Read_a_file_character_by_character_UTF8;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes;

function GetNextCharacter(StreamReader: TStreamReader): char;
begin
  Result := chr(StreamReader.Read);
end;

const
  FileName: TFileName = 'input.txt';

begin
  if not FileExists(FileName) then
    raise Exception.Create('Error: File not exist.');

  var F := TStreamReader.Create(FileName, TEncoding.UTF8);

  while not F.EndOfStream do
  begin
    var c := GetNextCharacter(F);
    write(c);
  end;
  readln;
end.
