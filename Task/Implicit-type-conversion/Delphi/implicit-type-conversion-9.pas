program Implicit_type_conversion;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type
  TFloatInt = record
    value: Double;
    class operator Implicit(a: Double): TFloatInt;
    class operator Implicit(a: Integer): TFloatInt;
    class operator Implicit(a: TFloatInt): Double;
    class operator Implicit(a: TFloatInt): Integer;
    class operator Implicit(a: TFloatInt): string;
    class operator Implicit(a: string): TFloatInt;
  end;


{ TFloatInt }

class operator TFloatInt.Implicit(a: Double): TFloatInt;
begin
  Result.value := a;
end;

class operator TFloatInt.Implicit(a: Integer): TFloatInt;
begin
  Result.value := a;
end;

class operator TFloatInt.Implicit(a: TFloatInt): Double;
begin
  Result := a.value;
end;

class operator TFloatInt.Implicit(a: TFloatInt): Integer;
begin
  Result := Round(a.value);
end;

class operator TFloatInt.Implicit(a: string): TFloatInt;
begin
  Result.value := StrToFloatDef(a, 0.0);
end;

class operator TFloatInt.Implicit(a: TFloatInt): string;
begin
  Result := FloatToStr(a.value);
end;

procedure Print(s: string);
begin
  Writeln(s);
end;

var
  val:TFloatInt;
  valInt:Integer;
begin
  // implicit from double
  val := 3.1416;

  // implicit to string
  Print(val);     // 3.1416

  // implicit to integer
  valInt := val;
  Writeln(valInt); // 3

  // implicit from integer
  val := valInt;

  // implicit to string
  Print(val);      // 3

  readln;
end.
