program Deal_cards_for_FreeCell;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  TRandom = record
    Seed: Int64;
    function Next: Integer;
  end;

  TCard = record
    const
      kSuits = '♣♦♥♠';
      kValues = 'A23456789TJQK';
    var
      Value: Integer;
      Suit: Integer;
    procedure Create(rawvalue: Integer); overload;
    procedure Create(value, suit: Integer); overload;
    procedure Assign(other: TCard);
    function ToString: string;
  end;

  TDeck = record
    Cards: TArray<TCard>;
    procedure Create(Seed: Integer);
    function ToString: string;
  end;

{ TRandom }

function TRandom.Next: Integer;
begin
  Seed := ((Seed * 214013 + 2531011) and Integer.MaxValue);
  Result := Seed shr 16;
end;

{ TCard }

procedure TCard.Create(rawvalue: Integer);
begin
  Create(rawvalue div 4, rawvalue mod 4);
end;

procedure TCard.Assign(other: TCard);
begin
  Create(other.Value, other.Suit);
end;

procedure TCard.Create(value, suit: Integer);
begin
  self.Value := value;
  self.Suit := suit;
end;

function TCard.ToString: string;
begin
  result := format('%s%s', [kValues[value + 1], kSuits[suit + 1]]);
end;

{ TDeck }

procedure TDeck.Create(Seed: Integer);
var
  r: TRandom;
  i, j: integer;
  tmp: Tcard;
begin
  r.Seed := Seed;
  SetLength(Cards, 52);
  for i := 0 to 51 do
    Cards[i].Create(51 - i);
  for i := 0 to 50 do
  begin
    j := 51 - (r.Next mod (52 - i));
    tmp.Assign(Cards[i]);
    Cards[i].Assign(Cards[j]);
    Cards[j].Assign(tmp);
  end;
end;

function TDeck.ToString: string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to length(Cards) - 1 do
  begin
    Result := Result + Cards[i].ToString;
    if i mod 8 = 7 then
      Result := Result + #10
    else
      Result := Result + ' ';
  end;
end;

var
  Deck: TDeck;

begin
  Deck.Create(1);
  Writeln('Deck 1'#10, Deck.ToString, #10);
  Deck.Create(617);
  Writeln('Deck 617'#10, Deck.ToString);
  readln;
end.
