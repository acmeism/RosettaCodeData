program Globally_replace_text_in_several_files;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.IoUtils;

procedure StringReplaceByFile(_old, _new: string; FileName: TFilename;
  ReplaceFlags: TReplaceFlags = []); overload
var
  Text: string;
begin
  if not FileExists(FileName) then
    exit;
  Text := TFile.ReadAllText(FileName);
  TFile.Delete(FileName);
  TFile.WriteAllText(StringReplace(Text, _old, _new, ReplaceFlags), FileName);
end;

procedure StringReplaceByFile(_old, _new: string; FileNames: TArray<TFileName>;
  ReplaceFlags: TReplaceFlags = []); overload;
begin
  for var fn in FileNames do
    StringReplaceByFile(_old, _new, fn);
end;

begin
  StringReplaceByFile('Goodbye London!', 'Hello New York!', ['a.txt', 'b.txt', 'c.txt']);
end.
