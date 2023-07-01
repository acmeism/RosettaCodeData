program Best_shuffle;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Generics.Collections;

type
  TShuffledString = record
  private
    original: string;
    Shuffled: TStringBuilder;
    ignoredChars: Integer;
    procedure DetectIgnores;
    procedure Shuffle;
    procedure Swap(pos1, pos2: Integer);
    function TrySwap(pos1, pos2: Integer): Boolean;
    function GetShuffled: string;
  public
    class operator Implicit(convert: string): TShuffledString;
    constructor Create(Word: string);
    procedure Free;
    property Ignored: integer read ignoredChars;
    property ToString: string read GetShuffled;
  end;

{ TShuffledString }

procedure TShuffledString.Swap(pos1, pos2: Integer);
var
  temp: char;
begin
  temp := shuffled[pos1];
  shuffled[pos1] := shuffled[pos2];
  shuffled[pos2] := temp;
end;

function TShuffledString.TrySwap(pos1, pos2: Integer): Boolean;
begin
  if (original[pos1] = shuffled[pos2]) or (original[pos2] = shuffled[pos1]) then
    Exit(false)
  else
    Exit(true);
end;

procedure TShuffledString.Shuffle;
var
  length, swaps: Integer;
  used: TList<Integer>;
  i, j, k: Integer;
begin
  Randomize;

  length := original.Length;
  used := TList<Integer>.create();

  for i := 0 to length - 1 do
  begin
    swaps := 0;
    while used.Count <= (length - i) do
    begin
      j := i + Random(length - 1 - i);

      if (original[i] <> original[j]) and TrySwap(i, j) and (not used.Contains(j)) then
      begin
        Swap(i, j);
        Inc(swaps);
        break;
      end
      else
        used.Add(j);
    end;

    if swaps = 0 then
    begin
      for k := i downto 0 do
      begin
        if TrySwap(i, k) then
          Swap(i, k);
      end;
    end;
    used.Clear();
  end;
  used.Free;
end;

constructor TShuffledString.Create(Word: string);
begin
  original := Word;
  shuffled := TStringBuilder.create(Word);
  Shuffle();
  DetectIgnores();
end;

procedure TShuffledString.DetectIgnores;
var
  ignores, i: Integer;
begin
  ignores := 0;
  for i := 0 to original.Length - 1 do
  begin
    if original[i] = shuffled[i] then
      Inc(ignores);
  end;
  ignoredChars := ignores;
end;

procedure TShuffledString.Free;
begin
  Shuffled.Free;
end;

function TShuffledString.GetShuffled: string;
begin
  result := shuffled.ToString();
end;

class operator TShuffledString.Implicit(convert: string): TShuffledString;
begin
  result := TShuffledString.Create(convert);
end;

var
  words: array of string;
  Word: TShuffledString;
  w: string;

begin
  words := ['abracadabra', 'seesaw', 'elk', 'grrrrrr', 'up', 'a'];
  for w in words do
  begin
    Word := w;
    writeln(format('%s, %s, (%d)', [Word.Original, Word.ToString, Word.Ignored]));
    Word.Free;
  end;
  Readln;
end.
