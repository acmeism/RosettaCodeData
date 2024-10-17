program Abbreviations_Automatic;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Generics.Collections,
  System.IOUtils;

function DistinctStrings(strs: TArray<string>): TArray<string>;
begin
  var l := length(strs);
  var _set := TDictionary<string, Boolean>.Create;
  SetLength(result, 0);
  for var str in strs do
  begin
    if not _set.ContainsKey(str) then
    begin
      SetLength(result, Length(result) + 1);
      result[High(result)] := str;
      _set.AddOrSetValue(str, true);
    end;
  end;
  _set.free;
end;

function takeRunes(s: string; n: Integer): string;
begin
  var i := 0;
  for var j := 0 to s.Length - 1 do
  begin
    if i = n then
      exit(s.Substring(0, j));
    inc(i);
  end;
  Result := s;
end;

begin
  var lines := TFile.ReadAllLines('days_of_week.txt');

  var lineCount := 0;
  while lineCount < length(Lines) do
  begin
    var line := lines[lineCount].Trim;
    inc(lineCount);
    if line.IsEmpty then
    begin
      Writeln;
      Continue;
    end;

    var days := line.Split([' '], TStringSplitOptions.ExcludeEmpty);
    var daysLen := Length(days);
    if daysLen <> 7 then
    begin
      Writeln('There aren''t 7 days in line', lineCount);
      Readln;
      halt;
    end;

    if Length(distinctStrings(days)) <> 7 then
    begin
      writeln(' infinity ', line);
      Continue;
    end;

    var abbrevLen := 0;
    while True do
    begin
      var abbrevs: TArray<string>;
      SetLength(abbrevs, daysLen);

      for var i := 0 to daysLen - 1 do
        abbrevs[i] := takeRunes(days[i], abbrevLen);

      if Length(distinctStrings(abbrevs)) = 7 then
      begin
        Writeln(abbrevLen.ToString.PadLeft(2).PadRight(3), line);
        Break;
      end;

      inc(abbrevLen);
    end;

  end;
  Readln;
end.
