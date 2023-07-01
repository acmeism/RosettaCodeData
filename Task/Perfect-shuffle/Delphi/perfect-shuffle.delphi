program Perfect_shuffle;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  TDeck = record
    Cards: TArray<Integer>;
    Len: Integer;
    constructor Create(deckSize: Integer); overload;
    constructor Create(deck: TDeck); overload;
    procedure shuffleDeck();
    class operator Equal(a, b: TDeck): boolean;
    function ShufflesRequired: Integer;
    procedure Assign(a: TDeck);
  end;

{ TDeck }

procedure TDeck.Assign(a: TDeck);
begin
  Len := a.Len;
  Cards := copy(a.Cards, 0, len);
end;

constructor TDeck.Create(deckSize: Integer);
begin
  if deckSize < 1 then
    raise Exception.Create('Error: Deck size must have above zero');

  if Odd(deckSize) then
    raise Exception.Create('Error: Deck size must be even');

  SetLength(Cards, deckSize);
  Len := deckSize;

  for var i := 0 to High(Cards) do
    Cards[i] := i;
end;

constructor TDeck.Create(deck: TDeck);
begin
  Assign(deck);
end;

class operator TDeck.Equal(a, b: TDeck): boolean;
begin
  if a.len <> b.len then
    raise Exception.Create('Error: Decks aren''t equally sized');

  if a.Len = 0 then
    exit(True);

  for var i := 0 to a.Len - 1 do
    if a.Cards[i] <> b.Cards[i] then
      exit(False);

  Result := True;
end;

procedure TDeck.shuffleDeck;
var
  tmp: TArray<Integer>;
begin
  SetLength(tmp, len);
  for var i := 0 to len div 2 - 1 do
  begin
    tmp[i * 2] := Cards[i];
    tmp[i * 2 + 1] := Cards[len div 2 + i];
  end;
  Cards := copy(tmp, 0, len);
end;

function TDeck.ShufflesRequired: Integer;
var
  ref: TDeck;
begin
  Result := 1;
  ref := TDeck.Create(self);
  shuffleDeck;
  while not (self = ref) do
  begin
    shuffleDeck;
    inc(Result);
  end;
end;

const
  cases: TArray<Integer> = [8, 24, 52, 100, 1020, 1024, 10000];

begin
  for var size in cases do
  begin
    var deck := TDeck.Create(size);
    writeln(format('Cards count: %d, shuffles required: %d', [size, deck.ShufflesRequired]));
  end;
  readln;
end.
