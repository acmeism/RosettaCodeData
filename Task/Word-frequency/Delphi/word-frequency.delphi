program Word_frequency;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.IOUtils,
  System.Generics.Collections,
  System.Generics.Defaults,
  System.RegularExpressions;

type
  TWords = TDictionary<string, Integer>;

  TFreqPair = TPair<string, Integer>;

  TFreq = TArray<TFreqPair>;

function CreateValueCompare: IComparer<TFreqPair>;
begin
  Result := TComparer<TFreqPair>.Construct(
    function(const Left, Right: TFreqPair): Integer
    begin
      Result := Right.Value - Left.Value;
    end);
end;

function WordFrequency(const Text: string): TFreq;
var
  words: TWords;
  match: TMatch;
  w: string;
begin
  words := TWords.Create();
  match := TRegEx.Match(Text, '\w+');
  while match.Success do
  begin
    w := match.Value;
    if words.ContainsKey(w) then
      words[w] := words[w] + 1
    else
      words.Add(w, 1);
    match := match.NextMatch();
  end;

  Result := words.ToArray;
  words.Free;
  TArray.Sort<TFreqPair>(Result, CreateValueCompare);
end;

var
  Text: string;
  rank: integer;
  Freq: TFreq;
  w: TFreqPair;

begin
  Text := TFile.ReadAllText('135-0.txt').ToLower();

  Freq := WordFrequency(Text);

  Writeln('Rank  Word  Frequency');
  Writeln('====  ====  =========');

  for rank := 1 to 10 do
  begin
    w := Freq[rank - 1];
    Writeln(format('%2d   %6s   %5d', [rank, w.Key, w.Value]));
  end;

  readln;
end.
