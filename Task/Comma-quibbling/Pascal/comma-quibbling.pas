program CommaQuibbling;

uses
  SysUtils,
  Classes,
  StrUtils;

const
  OuterBracket =['[', ']'];

type

{$IFNDEF FPC}
  SizeInt = LongInt;
{$ENDIF}



  { TCommaQuibble }

  TCommaQuibble = class(TStringList)
  private
    function GetCommaquibble: string;
    procedure SetCommaQuibble(AValue: string);
  public
    property CommaQuibble: string read GetCommaquibble write SetCommaQuibble;
  end;

{$IFNDEF FPC} // Delphi support

function WordPosition(const N: Integer; const S: string; const WordDelims:
  TSysCharSet): SizeInt;
var
  PS, P, PE: PChar;
  Count: Integer;
begin
  Result := 0;
  Count := 0;
  PS := PChar(pointer(S));
  PE := PS + Length(S);
  P := PS;
  while (P < PE) and (Count <> N) do
  begin
    while (P < PE) and (P^ in WordDelims) do
      inc(P);
    if (P < PE) then
      inc(Count);
    if (Count <> N) then
      while (P < PE) and not (P^ in WordDelims) do
        inc(P)
    else
      Result := (P - PS) + 1;
  end;
end;

function ExtractWordPos(N: Integer; const S: string; const WordDelims:
  TSysCharSet; out Pos: Integer): string;
var
  i, j, l: SizeInt;
begin
  j := 0;
  i := WordPosition(N, S, WordDelims);
  if (i > High(Integer)) then
  begin
    Result := '';
    Pos := -1;
    Exit;
  end;
  Pos := i;
  if (i <> 0) then
  begin
    j := i;
    l := Length(S);
    while (j <= l) and not (S[j] in WordDelims) do
      inc(j);
  end;
  SetLength(Result, j - i);
  if ((j - i) > 0) then
    Result := copy(S, i, j - i);
end;

function ExtractWord(N: Integer; const S: string; const WordDelims: TSysCharSet):
  string; inline;
var
  i: SizeInt;
begin
  Result := ExtractWordPos(N, S, WordDelims, i);
end;
{$ENDIF}

{ TCommaQuibble }

procedure TCommaQuibble.SetCommaQuibble(AValue: string);
begin
  AValue := ExtractWord(1, AValue, OuterBracket);
  commatext := AValue;
end;

function TCommaQuibble.GetCommaquibble: string;
var
  x: Integer;
  Del: string;
begin
  result := '';
  Del := ', ';
  for x := 0 to Count - 1 do
  begin
    result := result + Strings[x];
    if x = Count - 2 then
      Del := ' and '
    else if x = Count - 1 then
      Del := '';
    result := result + Del;
  end;
  result := '{' + result + '}';
end;

const
  TestData: array[0..7] of string = ('[]', '["ABC"]', '["ABC", "DEF"]',
    '["ABC", "DEF", "G", "H"]', '', '"ABC"', '"ABC", "DEF"', '"ABC", "DEF", "G", "H"');

var
  Quibble: TCommaQuibble;
  TestString: string;

begin
  Quibble := TCommaQuibble.Create;

  for TestString in TestData do
  begin
    Quibble.CommaQuibble := TestString;
    writeln(Quibble.CommaQuibble);
  end;
end.
