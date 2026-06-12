program FloatToBinTest;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Math;

function IntToBin(value: Int64): string;
var
  i, bit: Integer;
begin
  Result := '';

  for i := 63 downto 0 do
  begin
    bit := (value shr i) and 1;
    if (bit = 0) and Result.IsEmpty then
      Continue;
    Result := Result + bit.ToString
  end;
end;

function BinToInt(value: string): Int64;
var
  i, Alength: Integer;
  bit: Int64;
begin
  Result := 0;
  Alength := Length(value);
  for i := Alength downto 1 do
  begin
    bit := ord(value[i] = '1');
    Result := Result or (bit shl (Alength - i));
  end;
end;

function FloatToBin(value: Extended): string;
var
  int, bit: Int64;
  f: Extended;
begin
  int := Trunc(value);
  Result := IntToBin(int);

  f := Frac(value);
  if f > 0 then
    Result := Result + '.';

  while f > 0 do
  begin
    f := f * 2;
    bit := Trunc(f);
    Result := Result + bit.ToString;
    f := f - bit;
  end;
end;

function BinToFloat(value: string): Extended;
var
  num, den: Extended;
begin
  if value.IndexOf('.') = -1 then
    exit(BinToInt(value));

  num := BinToInt(value.Replace('.', '', []));
  den := BinToInt('1' + value.Split(['.'])[1].Replace('1', '0', [rfReplaceAll]));

  Result := num / den;
end;

var
  f: Extended;
  s: string;

begin
  f := 23.34375;
  Writeln(Format('%.5f'^I' => %s', [f, FloatToBin(23.34375)]));

  s := '1011.11101';
  Writeln(Format('%s'^I' => %.5f', [s, BinToFloat('1011.11101')]));

  Readln;
end.
