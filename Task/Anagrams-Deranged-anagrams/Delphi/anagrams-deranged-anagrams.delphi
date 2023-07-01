program Anagrams_Deranged;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Classes,
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

function IsDerangement(word1, word2: string): Boolean;
var
  i: Integer;
begin
  for i := 1 to word1.Length do
    if word1[i] = word2[i] then
      exit(False);
  Result := True;
end;

var
  Dict: TStringList;
  Count, Index: Integer;
  words: string;
  StopWatch: TStopwatch;

begin
  StopWatch := TStopwatch.Create;
  StopWatch.Start;

  Dict := TStringList.Create();
  Dict.LoadFromFile('unixdict.txt');

  Dict.CustomSort(CompareLength);

  Index := Dict.Count - 1;
  words := '';
  Count := 1;

  while Index - Count >= 0 do
  begin
    if IsAnagram(Dict[Index], Dict[Index - Count]) then
    begin
      if IsDerangement(Dict[Index], Dict[Index - Count]) then
      begin
        words := Dict[Index] + ' - ' + Dict[Index - Count];
        Break;
      end;
      Inc(Count);
    end
    else
    begin
      Dec(Index, Count);
      Count := 1;
    end;
  end;

  StopWatch.Stop;

  Writeln(Format('Time pass: %d ms [i7-4500U Windows 7]', [StopWatch.ElapsedMilliseconds]));

  writeln(#10'Longest derangement words are:'#10#10, words);

  Dict.Free;
  Readln;
end.
