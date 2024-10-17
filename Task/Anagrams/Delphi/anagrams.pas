program AnagramsTest;

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

function Split(s: string; var Count: Integer; var words: string): Boolean;
var
  sCount: string;
begin
  sCount := s.Substring(0, 4);
  words := s.Substring(5);
  Result := TryStrToInt(sCount, Count);
end;

function CompareLength(List: TStringList; Index1, Index2: Integer): Integer;
begin
  result := List[Index1].Length - List[Index2].Length;
  if Result = 0 then
    Result := CompareText(Sort(List[Index2]), Sort(List[Index1]));
end;

var
  Dict: TStringList;
  i, j, Count, MaxCount, WordLength, Index: Integer;
  words: string;
  StopWatch: TStopwatch;

begin
  StopWatch := TStopwatch.Create;
  StopWatch.Start;

  Dict := TStringList.Create();
  Dict.LoadFromFile('unixdict.txt');

  Dict.CustomSort(CompareLength);

  Index := 0;
  words := Dict[Index];
  Count := 1;

  while Index + Count < Dict.Count do
  begin
    if IsAnagram(Dict[Index], Dict[Index + Count]) then
    begin
      words := words + ',' + Dict[Index + Count];
      Dict[Index + Count] := '';
      inc(Count);
    end
    else
    begin
      Dict[Index] := format('%.4d', [Count]) + ',' + words;
      inc(Index, Count);
      words := Dict[Index];
      Count := 1;
    end;
  end;

  // The last one not match any one
  if not Dict[Dict.count - 1].IsEmpty then
    Dict.Delete(Dict.count - 1);

  Dict.Sort;

  while Dict[0].IsEmpty do
    Dict.Delete(0);

  StopWatch.Stop;

  Writeln(Format('Time pass: %d ms [i7-4500U Windows 7]', [StopWatch.ElapsedMilliseconds]));

  Split(Dict[Dict.count - 1], MaxCount, words);
  writeln(#10'The anagrams that contain the most words, has ', MaxCount, ' words:'#10);
  writeln('Words found:'#10);

  Writeln('  ', words);

  for i := Dict.Count - 2 downto 0 do
  begin
    Split(Dict[i], Count, words);
    if Count = MaxCount then
      Writeln('  ', words)
    else
      Break;
  end;

  Dict.Free;
  Readln;
end.
