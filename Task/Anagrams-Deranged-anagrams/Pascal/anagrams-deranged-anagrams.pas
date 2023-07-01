program Anagrams_Deranged;
{$IFDEF FPC}
  {$MODE Delphi}
  {$Optimization ON,ALL}
uses
  SysUtils,
  Classes;
{$ELSE}
  {$APPTYPE CONSOLE}
uses
  System.SysUtils,
  System.Classes,
  {$R *.res}
{$ENDIF}

function Sort(const s: string):string;
//insertion sort
var
  pRes : pchar;
  i, j, aLength: NativeInt;
  tmpc: Char;
begin
  aLength := s.Length;

  if aLength = 0 then
    exit('');

  Result := s;
  //without it, s will be sorted
  UniqueString(Result);
  //insertion sort
  pRes := pChar(Result);
  dec(aLength,1);
  for i := 0 to aLength do
  Begin
    tmpc := pRes[i];
    j := i-1;
    while (j>=0) AND (tmpc < pRes[j]) do
    Begin
      pRes[j+1] := pRes[j];
      dec(j);
    end;
    inc(j);
    pRes[j]:= tmpc;
  end;
end;

function CompareLength(List: TStringList; Index1, Index2: longInt): longInt;
begin
  result := List[Index1].Length - List[Index2].Length;
  IF result = 0 then
    result := CompareStr(List[Index1],List[Index2]);
end;

function IsDerangement(const word1, word2: string): Boolean;
var
  i: NativeInt;
begin
  for i := word1.Length downto 1 do
    if word1[i] = word2[i] then
      exit(False);
  Result := True;
end;

var
  Dict,SortDict: TStringList;
  words: string;
  StopWatch: Int64;
  Count, Index: NativeInt;

begin
  Dict := TStringList.Create();
  Dict.LoadFromFile('unixdict.txt');

  StopWatch := GettickCount64;
  SortDict:= TStringList.Create();
  SortDict.capacity := Dict.Count;
  For Index := 0 to Dict.Count - 1  do
  Begin
    SortDict.Add(Sort(Dict[Index]));
    //remember the origin in Dict
    SortDict.Objects[Index]:= TObject(Index);
  end;

  SortDict.CustomSort(CompareLength);

  Index := Dict.Count - 1;
  words := '';
  Count := 1;

  while Index - Count >= 0 do
  begin
    if SortDict[Index]= SortDict[Index - Count] then
    begin
      if IsDerangement(Dict[NativeInt(SortDict.Objects[Index])],
         Dict[NativeInt(SortDict.Objects[Index - Count])]) then
      begin
        words := Dict[NativeInt(SortDict.Objects[Index])] + ' - ' +
                 Dict[NativeInt(SortDict.Objects[Index - Count])];
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
  StopWatch := GettickCount64-StopWatch;
  Writeln(Format('Time pass: %d ms [AMD 2200G-Linux Fossa]',[StopWatch]));
  writeln(#10'Longest derangement words are:'#10#10, words);

  SortDict.free;
  Dict.Free;
end.
