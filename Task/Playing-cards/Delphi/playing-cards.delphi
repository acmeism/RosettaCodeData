program Cards;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes;

type
  TPip = (pTwo, pThree, pFour, pFive, pSix, pSeven, pEight, pNine, pTen, pJack, pQueen, pKing, pAce);
  TSuite = (sDiamonds, sSpades, sHearts, sClubs);

const
  cPipNames: array[TPip] of string = ('2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A');
  cSuiteNames: array[TSuite] of string = ('Diamonds', 'Spades', 'Hearts', 'Clubs');

type
  TCard = class
  private
    FSuite: TSuite;
    FPip: TPip;
  public
    constructor Create(aSuite: TSuite; aPip: TPip);
    function ToString: string; override;

    property Pip: TPip read FPip;
    property Suite: TSuite read FSuite;
  end;

  TDeck = class
  private
    FCards: TList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Shuffle;
    function Deal: TCard;
    function ToString: string; override;
  end;

{ TCard }

constructor TCard.Create(aSuite: TSuite; aPip: TPip);
begin
  FSuite := aSuite;
  FPip := aPip;
end;

function TCard.ToString: string;
begin
  Result := Format('%s of %s', [cPipNames[Pip], cSuiteNames[Suite]])
end;

{ TDeck }

constructor TDeck.Create;
var
  pip: TPip;
  suite: TSuite;
begin
  FCards := TList.Create;
  for suite := Low(TSuite) to High(TSuite) do
    for pip := Low(TPip) to High(TPip) do
      FCards.Add(TCard.Create(suite, pip));
end;

function TDeck.Deal: TCard;
begin
  Result := FCards[0];
  FCards.Delete(0);
end;

destructor TDeck.Destroy;
var
  i: Integer;
  c: TCard;
begin
  for i := FCards.Count - 1 downto 0 do begin
    c := FCards[i];
    FCards.Delete(i);
    c.Free;
  end;
  FCards.Free;
  inherited;
end;

procedure TDeck.Shuffle;
var
  i, j: Integer;
  temp: TCard;
begin
  Randomize;
  for i := FCards.Count - 1 downto 0 do begin
    j := Random(FCards.Count);
    temp := FCards[j];
    FCards.Delete(j);
    FCards.Add(temp);
  end;
end;

function TDeck.ToString: string;
var
  i: Integer;
begin
  for i := 0 to FCards.Count - 1 do
    Writeln(TCard(FCards[i]).ToString);
end;

begin
  with TDeck.Create do
  try
    Shuffle;
    ToString;
    Writeln;
    with Deal do
    try
      Writeln(ToString);
    finally
      Free;
    end;
  finally
    Free;
  end;

  Readln;
end.
