program Abbreviations_Easy;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

const
  _TABLE_ =
    'Add ALTer  BAckup Bottom  CAppend Change SCHANGE  CInsert CLAst COMPress COpy ' +
    'COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find ' +
    'NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput ' +
    'Join SPlit SPLTJOIN  LOAD  Locate CLocate  LOWercase UPPercase  LPrefix MACRO ' +
    'MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD  Query  QUIT ' +
    'READ  RECover REFRESH RENum REPeat  Replace CReplace  RESet  RESTore  RGTLEFT ' +
    'RIght LEft  SAVE  SET SHift SI  SORT  SOS  STAck STATus  TOP TRAnsfer Type Up ';

function validate(commands, words: TArray<string>; minLens: TArray<Integer>):
  TArray<string>;
begin
  SetLength(result, 0);
  if Length(words) = 0 then
    exit;
  for var wd in words do
  begin
    var matchFound := false;
    var wlen := wd.Length;
    for var i := 0 to High(commands) do
    begin
      var command := commands[i];
      if (minLens[i] = 0) or (wlen < minLens[i]) or (wlen > length(command)) then
        continue;

      var c := command.ToUpper;
      var w := wd.ToUpper;
      if c.StartsWith(w) then
      begin
        SetLength(result, Length(result) + 1);
        result[High(result)] := c;
        matchFound := True;
        Break;
      end;
    end;

    if not matchFound then
    begin
      SetLength(result, Length(result) + 1);
      result[High(result)] := 'error*';
    end;
  end;
end;

begin
  var table := _TABLE_.Trim;
  var commands := table.Split([' '], TStringSplitOptions.ExcludeEmpty);
  var clen := Length(commands);
  var minLens: TArray<integer>;
  SetLength(minLens, clen);
  for var i := 0 to clen - 1 do
  begin
    var count := 0;
    for var c in commands[i] do
    begin
      if (c >= 'A') and (c <= 'Z') then
        inc(count);
    end;
    minLens[i] := count;
  end;

  var sentence := 'riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin';
  var words := sentence.Split([' '], TStringSplitOptions.ExcludeEmpty);
  var results := validate(commands, words, minLens);
  Write('user words: ');
  for var j := 0 to Length(words) - 1 do
    Write(words[j].PadRight(1 + length(results[j])));
  Write(#10, 'full words: ');
  Writeln(string.Join(' ', results));
  Readln;
end.
