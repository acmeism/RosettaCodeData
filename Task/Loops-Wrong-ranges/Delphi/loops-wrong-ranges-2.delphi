program Wrong_rangesEnumerator;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  TRange = record
  private
    Fincrement: Integer;
    FIndex: Integer;
    FStart, FStop, FValue: Integer;
    function GetCurrent: Integer; inline;
  public
    constructor Create(start, stop, Increment: Integer);
    function MoveNext: Boolean; inline;
    function GetEnumerator: TRange;
    property Current: Integer read GetCurrent;
  end;

{ TEnumerator<T> }

constructor TRange.Create(start, stop, Increment: Integer);
begin
  FStart := start;
  FStop := stop;
  Fincrement := Increment;
  FValue := start - Increment;
end;

function TRange.GetCurrent: Integer;
begin
  Result := FValue;
end;

function TRange.GetEnumerator: TRange;
begin
  Result := self;
end;

function TRange.MoveNext: Boolean;
begin
  FValue := FValue + Fincrement;
  if (Fincrement > 0) and (FValue > FStop) then
    exit(False);

  if (Fincrement < 0) and (FValue < FStop) then
    exit(False);

  Result := True;
end;

procedure Example(start, stop, Increment: Integer; comment: string);
var
  MAX_ITER, iteration, i, e: Integer;
begin
  Write((comment + ' ').PadRight(50, '-') + ' ');
  MAX_ITER := 9;
  iteration := 0;

  for e in TRange.Create(start, stop, Increment) do
  begin
    Write(e: 2, ' ');
    inc(iteration);
    if iteration >= MAX_ITER then
      Break;
  end;

  Writeln;
end;

begin
  Example(-2, 2, 1, 'Normal');
  Example(-2, 2, 0, 'Zero increment');
  Example(-2, 2, -1, 'Increments away from stop value');
  Example(-2, 2, 10, 'First increment is beyond stop value');
  Example(2, -2, 1, 'Start more than stop: positive increment');
  Example(2, 2, 1, 'Start equal stop: positive increment');
  Example(2, 2, -1, 'Start equal stop: negative increment');
  Example(2, 2, 0, 'Start equal stop: zero increment');
  Example(0, 0, 0, 'Start equal stop equal zero: zero increment');
  Readln;
end.
