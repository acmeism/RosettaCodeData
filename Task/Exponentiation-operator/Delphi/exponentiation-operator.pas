program Exponentiation_operator;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  TDouble = record
    Value: Double;
    class operator Implicit(a: TDouble): Double;
    class operator Implicit(a: Double): TDouble;
    class operator Implicit(a: TDouble): string;
    class operator LogicalXor(a: TDouble; b: Integer): TDouble;
  end;

  TInteger = record
    Value: Integer;
    class operator Implicit(a: TInteger): Integer;
    class operator Implicit(a: Integer): TInteger;
    class operator Implicit(a: TInteger): string;
    class operator LogicalXor(a: TInteger; b: Integer): TInteger;
  end;

{ TDouble }

class operator TDouble.Implicit(a: TDouble): Double;
begin
  Result := a.Value;
end;

class operator TDouble.Implicit(a: Double): TDouble;
begin
  Result.Value := a;
end;

class operator TDouble.Implicit(a: TDouble): string;
begin
  Result := a.Value.ToString;
end;

class operator TDouble.LogicalXor(a: TDouble; b: Integer): TDouble;
var
  i: Integer;
  val: Double;
begin
  val := 1;
  for i := 1 to b do
    val := val * a.Value;
  Result.Value := val;
end;

{ TInteger }

class operator TInteger.Implicit(a: TInteger): Integer;
begin
  Result := a.Value;
end;

class operator TInteger.Implicit(a: Integer): TInteger;
begin
  Result.Value := a;
end;

class operator TInteger.Implicit(a: TInteger): string;
begin
  Result := a.Value.ToString;
end;

class operator TInteger.LogicalXor(a: TInteger; b: Integer): TInteger;
var
  val, i: Integer;
begin
  if b < 0 then
    raise Exception.Create('Expoent must be greater or equal zero');

  val := 1;
  for i := 1 to b do
    val := val * a.Value;
  Result.Value := val;
end;

procedure Print(s: string);
begin
  Write(s);
end;

var
  valF: TDouble;
  valI: TInteger;

begin
  valF := 5.5;
  valI := 5;

  // Delphi  don't have "**" or "^" operator for overload,
  // "xor" operator has used instead
  Print('5^5 = ');
  Print(valI xor 5);
  print(#10);

  Print('5.5^5 = ');
  Print(valF xor 5);
  print(#10);

  readln;
end.
