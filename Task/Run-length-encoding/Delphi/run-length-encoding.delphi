program RunLengthTest;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  TRLEPair = record
    count: Integer;
    letter: Char;
  end;

  TRLEncoded = TArray<TRLEPair>;

  TRLEncodedHelper = record helper for TRLEncoded
  public
    procedure Clear;
    function Add(c: Char): Integer;
    procedure Encode(Data: string);
    function Decode: string;
    function ToString: string;
  end;

{ TRLEncodedHelper }

function TRLEncodedHelper.Add(c: Char): Integer;
begin
  SetLength(self, length(self) + 1);
  Result := length(self) - 1;
  with self[Result] do
  begin
    count := 1;
    letter := c;
  end;
end;

procedure TRLEncodedHelper.Clear;
begin
  SetLength(self, 0);
end;

function TRLEncodedHelper.Decode: string;
var
  p: TRLEPair;
begin
  Result := '';
  for p in Self do
    Result := Result + string.Create(p.letter, p.count);
end;

procedure TRLEncodedHelper.Encode(Data: string);
var
  pivot: Char;
  i, index: Integer;
begin
  Clear;
  if Data.Length = 0 then
    exit;

  pivot := Data[1];
  index := Add(pivot);

  for i := 2 to Data.Length do
  begin
    if pivot = Data[i] then
      inc(self[index].count)
    else
    begin
      pivot := Data[i];
      index := Add(pivot);
    end;
  end;
end;

function TRLEncodedHelper.ToString: string;
var
  p: TRLEPair;
begin
  Result := '';
  for p in Self do
    Result := Result + p.count.ToString + p.letter;
end;

const
  Input = 'WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW';

var
  Data: TRLEncoded;

begin
  Data.Encode(Input);
  Writeln(Data.ToString);
  writeln(Data.Decode);
  Readln;
end.
