program Long_multiplication;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  TLongMul = record
  private
    function Add(x, y: TArray<byte>): TArray<byte>;
    function ByteToString(b: TArray<byte>): Ansistring;
    function d(b: byte): Byte;
    function mulDigit(x: TArray<byte>; y: byte): TArray<byte>;
    function mul(x1, y1: AnsiString): AnsiString;
  public
    value: string;
    class operator Multiply(a, b: TLongMul): TLongMul;
    class operator Implicit(a: TLongMul): string;
    class operator Implicit(a: string): TLongMul;
  end;

function TLongMul.d(b: byte): Byte;
begin
  if (b < ord('0')) or (b > ord('9')) then
    raise Exception.Create('digit 0-9 expected: ' + ord(b).ToString);
  Result := ord(b) - ord('0');
end;

class operator TLongMul.Implicit(a: string): TLongMul;
begin
  Result.value := a;
end;

class operator TLongMul.Implicit(a: TLongMul): string;
begin
  Result := a.value;
end;

function TLongMul.Add(x, y: TArray<byte>): TArray<byte>;
begin
  if length(x) < Length(y) then
  begin
    var tmp := y;
    y := x;
    x := tmp;
  end;

  var b: TArray<byte>;
  SetLength(b, length(x) + 1);
  var c: byte := 0;
  for var i := 1 to Length(x) do
  begin
    if i <= Length(y) then
      c := c + d(y[Length(y) - i]);
    var s := d(x[Length(x) - i]) + c;
    c := s div 10;
    b[length(b) - i] := (s mod 10) + ord('0');
  end;
  if c = 0 then
  begin
    Result := b;
    Delete(Result, 0, 1);
    exit;
  end;

  b[0] := c + ord('0');
  Result := b;
end;

function TLongMul.mulDigit(x: TArray<byte>; y: byte): TArray<byte>;
begin
  if y = ord('0') then
  begin
    SetLength(result, 1);
    Result[0] := y;
    exit
  end;

  y := d(y);
  var b: TArray<byte>;
  SetLength(b, length(x) + 1);
  var c: byte := 0;
  for var i := 1 to Length(x) do
  begin
    var s := d(x[Length(x) - i]) * y + c;
    c := s div 10;
    b[length(b) - i] := (s mod 10) + ord('0');
  end;

  if c = 0 then
  begin
    Result := b;
    Delete(Result, 0, 1);
    exit;
  end;

  b[0] := c + ord('0');
  Result := b;
end;

class operator TLongMul.Multiply(a, b: TLongMul): TLongMul;
begin
  Result.value := a.mul(a, b);
end;

function TLongMul.ByteToString(b: TArray<byte>): Ansistring;
begin
  SetLength(Result, length(b));
  move(b[0], Result[1], length(b));
end;

function TLongMul.mul(x1, y1: AnsiString): AnsiString;
var
  x, y: TArray<byte>;
  res: TArray<byte>;
begin
  SetLength(x, length(x1));
  move(x1[1], x[0], length(x1));

  SetLength(y, length(y1));
  move(y1[1], y[0], length(y1));

  res := mulDigit(x, y[length(y) - 1]);

  var zeros: TArray<byte> := [];

  for var i := 2 to Length(y) do
  begin
    SetLength(zeros, Length(zeros) + 1);
    zeros[High(zeros)] := ord('0');

    res := add(res, Concat(mulDigit(x, y[Length(y) - i]), zeros));
  end;

  Result := ByteToString(res);
end;

const
  validate = '340282366920938463463374607431768211456';

var
  num: TLongMul;

begin
  num.value := '18446744073709551616';

  Writeln((num * num).value);
  Writeln(validate);
  Readln;
end.
