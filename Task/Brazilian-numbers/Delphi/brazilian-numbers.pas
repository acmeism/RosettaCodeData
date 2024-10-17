program Brazilian_numbers;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type
  TBrazilianNumber = record
  private
    FValue: Integer;
    FIsBrazilian: Boolean;
    FIsPrime: Boolean;
    class function SameDigits(a, b: Integer): Boolean; static;
    class function CheckIsBrazilian(a: Integer): Boolean; static;
    class function CheckIsPrime(a: Integer): Boolean; static;
    constructor Create(const Number: Integer);
    procedure SetValue(const Value: Integer);
  public
    property Value: Integer read FValue write SetValue;
    property IsBrazilian: Boolean read FIsBrazilian;
    property IsPrime: Boolean read FIsPrime;
  end;

{ TBrazilianNumber }

class function TBrazilianNumber.CheckIsBrazilian(a: Integer): Boolean;
var
  b: Integer;
begin
  if (a < 7) then
    Exit(false);

  if (a mod 2 = 0) then
    Exit(true);

  for b := 2 to a - 2 do
  begin
    if (sameDigits(a, b)) then
      exit(True);
  end;
  Result := False;
end;

constructor TBrazilianNumber.Create(const Number: Integer);
begin
  SetValue(Number);
end;

class function TBrazilianNumber.CheckIsPrime(a: Integer): Boolean;
var
  d: Integer;
begin
  if (a < 2) then
    exit(False);

  if (a mod 2) = 0 then
    exit(a = 2);

  if (a mod 3) = 0 then
    exit(a = 3);

  d := 5;

  while (d * d <= a) do
  begin
    if (a mod d = 0) then
      Exit(false);
    inc(d, 2);

    if (a mod d = 0) then
      Exit(false);
    inc(d, 4);
  end;

  Result := True;
end;

class function TBrazilianNumber.SameDigits(a, b: Integer): Boolean;
var
  f: Integer;
begin
  f := a mod b;
  a := a div b;
  while a > 0 do
  begin
    if (a mod b) <> f then
      exit(False);
    a := a div b;
  end;
  Result := True;
end;

procedure TBrazilianNumber.SetValue(const Value: Integer);
begin
  if Value < 0 then
    FValue := 0
  else
    FValue := Value;
  FIsBrazilian := CheckIsBrazilian(FValue);
  FIsPrime := CheckIsPrime(FValue);
end;

const
  TextLabel: array[0..2] of string = ('', 'odd', 'prime');

var
  Number: TBrazilianNumber;
  Count: array[0..2] of Integer;
  i, j, left, Num: Integer;
  data: array[0..2] of string;

begin
  left := 3;
  for i := 0 to 99999 do
  begin
    if Number.Create(i).IsBrazilian then
      for j := 0 to 2 do
      begin

        if (Count[j] >= 20) and (j > 0) then
          continue;

        case j of
          0:
            begin
              inc(Count[j]);
              Num := i;
              if (Count[j] <= 20) then
                data[j] := data[j] + i.ToString + ' '
              else
                Continue;
            end;
          1:
            begin
              if Odd(i) then
              begin
                inc(Count[j]);
                data[j] := data[j] + i.ToString + ' ';
              end;
            end;
          2:
            begin
              if Number.IsPrime then
              begin
                inc(Count[j]);
                data[j] := data[j] + i.ToString + ' ';
              end;
            end;
        end;
        if Count[j] = 20 then
          dec(left);
      end;
    if left = 0 then
      Break;
  end;

  while Count[0] < 100000 do
  begin
    inc(Num);
    if Number.Create(Num).IsBrazilian then
      inc(Count[0]);
  end;

  for i := 0 to 2 do
  begin
    Writeln(#10'First 20 ' + TextLabel[i] + ' Brazilian numbers:');
    Writeln(data[i]);
  end;

  Writeln('The 100,000th Brazilian number: ', Num);
  readln;
end.
