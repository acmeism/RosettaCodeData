program Abbreviations_Easy;
{$IFDEF WINDOWS}
  {$APPTYPE CONSOLE}
{$ENDIF}
{$IFDEF FPC}
  {$MODE DELPHI}
  uses
    SysUtils;
{$ELSE}
 uses
    System.SysUtils;
{$ENDIF}

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
var
  wd,c,command,w : String;
  wdIdx,wlen,i : integer;
  matchFound : boolean;

begin
  SetLength(result, 0);
  if Length(words) = 0 then
    exit;
  for wdIdx := Low(words) to High(words) do
  begin
    wd := words[wdIdx];
    matchFound := false;
    wlen := wd.Length;
    for i := 0 to High(commands) do
    begin
      command := commands[i];
      if (minLens[i] = 0) or (wlen < minLens[i]) or (wlen > length(command)) then
        continue;

      c := command.ToUpper;
      w := wd.ToUpper;
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
var
  results,commands,words :TArray<string>;
  table,sentence :String;
  minLens: TArray<integer>;
  cLen,i,j,count : integer;
  c:char;
begin
  table := _TABLE_.Trim;
  commands := table.Split([' '], TStringSplitOptions.ExcludeEmpty);
  clen := Length(commands);
  SetLength(minLens, clen);
  for i := 0 to clen - 1 do
  begin
    count := 0;
    For j := length(commands[i]) downto 1 do
    begin
      c := commands[i][j];
      if (c >= 'A') and (c <= 'Z') then
        inc(count);
    end;
    minLens[i] := count;
  end;

  sentence := 'riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin';
  words := sentence.Split([' '], TStringSplitOptions.ExcludeEmpty);
  results := validate(commands, words, minLens);
  Write('user words: ');
  for j := 0 to Length(words) - 1 do
    Write(words[j].PadRight(1 + length(results[j])));
  Write(#10, 'full words: ');
// FOr fpc 3.0.4 on TIO.RUN
  for j := 0 to Length(words) - 1 do
    Write(results[j],' ');
// fpc 3.2.2 will do
//  Writeln(string.Join(' ', results));
  {$IFDEF WINDOWS}
  Readln;
  {$ENDIF}
end.
