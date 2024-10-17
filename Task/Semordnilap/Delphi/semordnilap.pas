program Semordnilap;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  System.Diagnostics;

function Sort(s: string): string;
var
  c: Char;
  i, j, aLength: Integer;
begin
  aLength := s.Length;

  if aLength = 0 then
    exit('');

  Result := s;

  for i := 1 to aLength - 1 do
    for j := i + 1 to aLength do
      if result[i] > result[j] then
      begin
        c := result[i];
        result[i] := result[j];
        result[j] := c;
      end;
end;

function IsAnagram(s1, s2: string): Boolean;
begin
  if s1.Length <> s2.Length then
    exit(False);

  Result := Sort(s1) = Sort(s2);

end;

function CompareLength(List: TStringList; Index1, Index2: Integer): Integer;
begin
  result := List[Index1].Length - List[Index2].Length;
  if Result = 0 then
    Result := CompareText(Sort(List[Index2]), Sort(List[Index1]));
end;

function IsSemordnilap(word1, word2: string): Boolean;
begin
  Result := SameText(word1, ReverseString(word2));
end;

var
  SemordnilapDict, Dict: TStringList;
  Count, Index, i, j: Integer;
  words: string;
  StopWatch: TStopwatch;

begin
  Randomize;
  StopWatch := TStopwatch.Create;
  StopWatch.Start;

  Dict := TStringList.Create();
  Dict.LoadFromFile('unixdict.txt');

  SemordnilapDict := TStringList.Create;

  Dict.CustomSort(CompareLength);

  Index := Dict.Count - 1;
  words := '';
  Count := 1;

  while Index - Count >= 0 do
  begin
    if IsAnagram(Dict[Index], Dict[Index - Count]) then
    begin
      if IsSemordnilap(Dict[Index], Dict[Index - Count]) then
      begin
        words := Dict[Index] + ' - ' + Dict[Index - Count];
        SemordnilapDict.Add(words);
      end;
      Inc(Count);
    end
    else
    begin
      if Count > 2 then
        for i := 1 to Count - 2 do
          for j := i + 1 to Count - 1 do
          begin
            if IsSemordnilap(Dict[Index - i], Dict[Index - j]) then
            begin
              words := Dict[Index - i] + ' - ' + Dict[Index - j];
              SemordnilapDict.Add(words);
            end;
          end;

      Dec(Index, Count);
      Count := 1;
    end;
  end;

  StopWatch.Stop;

  Writeln(Format('Time pass: %d ms [i7-4500U Windows 7]', [StopWatch.ElapsedMilliseconds]));

  writeln(#10'Semordnilap found: ', SemordnilapDict.Count);
  writeln(#10'Five random samples:'#10);

  for Index := 0 to 4 do
    writeln('  ', SemordnilapDict[Random(SemordnilapDict.Count)]);

  SemordnilapDict.SaveToFile('Semordnilap.txt');
  SemordnilapDict.Free;
  Dict.Free;
  Readln;
end.
