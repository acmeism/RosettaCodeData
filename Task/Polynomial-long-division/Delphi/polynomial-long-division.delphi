program Polynomial_long_division;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  PPolySolution = ^TPolySolution;

  TPolynomio = record
  private
    class function Degree(p: TPolynomio): Integer; static;
    class function ShiftRight(p: TPolynomio; places: Integer): TPolynomio; static;
    class function PolyMultiply(p: TPolynomio; m: double): TPolynomio; static;
    class function PolySubtract(p, s: TPolynomio): TPolynomio; static;
    class function PolyLongDiv(n, d: TPolynomio): PPolySolution; static;
    function GetSize: Integer;
  public
    value: TArray<Double>;
    class operator RightShift(p: TPolynomio; b: Integer): TPolynomio;
    class operator Multiply(p: TPolynomio; m: double): TPolynomio;
    class operator Subtract(p, s: TPolynomio): TPolynomio;
    class operator Divide(p, s: TPolynomio): PPolySolution;
    class operator Implicit(a: TArray<Double>): TPolynomio;
    class operator Implicit(a: TPolynomio): string;
    procedure Assign(other: TPolynomio); overload;
    procedure Assign(other: TArray<Double>); overload;
    property Size: Integer read GetSize;
    function ToString: string;
  end;

  TPolySolution = record
    Quotient, Remainder: TPolynomio;
    constructor Create(q, r: TPolynomio);
  end;

{ TPolynomio }

procedure TPolynomio.Assign(other: TPolynomio);
begin
  Assign(other.value);
end;

procedure TPolynomio.Assign(other: TArray<Double>);
begin
  SetLength(value, length(other));
  for var i := 0 to High(other) do
    value[i] := other[i];
end;

class function TPolynomio.Degree(p: TPolynomio): Integer;
begin
  var len := high(p.value);

  for var i := len downto 0 do
  begin
    if p.value[i] <> 0.0 then
      exit(i);
  end;
  Result := -1;
end;

class operator TPolynomio.Divide(p, s: TPolynomio): PPolySolution;
begin
  Result := PolyLongDiv(p, s);
end;

function TPolynomio.GetSize: Integer;
begin
  Result := Length(value);
end;

class operator TPolynomio.Implicit(a: TPolynomio): string;
begin
  Result := a.toString;
end;

class operator TPolynomio.Implicit(a: TArray<Double>): TPolynomio;
begin
  Result.Assign(a);
end;

class operator TPolynomio.Multiply(p: TPolynomio; m: double): TPolynomio;
begin
  Result := TPolynomio.PolyMultiply(p, m);
end;

class function TPolynomio.PolyLongDiv(n, d: TPolynomio): PPolySolution;
var
  Solution: TPolySolution;
begin
  if length(n.value) <> Length(d.value) then
    raise Exception.Create('Numerator and denominator vectors must have the same size');

  var nd := Degree(n);
  var dd := Degree(d);

  if dd < 0 then
    raise Exception.Create('Divisor must have at least one one-zero coefficient');

  if nd < dd then
    raise Exception.Create('The degree of the divisor cannot exceed that of the numerator');

  var n2, q: TPolynomio;
  n2.Assign(n);
  SetLength(q.value, length(n.value));

  while nd >= dd do
  begin
    var d2 := d shr (nd - dd);
    q.value[nd - dd] := n2.value[nd] / d2.value[nd];
    d2 := d2 * q.value[nd - dd];
    n2 := n2 - d2;
    nd := Degree(n2);
  end;
  new(Result);
  Result^.Create(q, n2);
end;

class function TPolynomio.PolyMultiply(p: TPolynomio; m: double): TPolynomio;
begin
  Result.Assign(p);
  for var i := 0 to High(p.value) do
    Result.value[i] := p.value[i] * m;
end;

class operator TPolynomio.RightShift(p: TPolynomio; b: Integer): TPolynomio;
begin
  Result := TPolynomio.ShiftRight(p, b);
end;

class function TPolynomio.ShiftRight(p: TPolynomio; places: Integer): TPolynomio;
begin
  Result.Assign(p);
  if places <= 0 then
    exit;

  var pd := Degree(p);

  Result.Assign(p);
  for var i := pd downto 0 do
  begin
    Result.value[i + places] := Result.value[i];
    Result.value[i] := 0.0;
  end;
end;

class operator TPolynomio.Subtract(p, s: TPolynomio): TPolynomio;
begin
  Result := TPolynomio.PolySubtract(p, s);
end;

class function TPolynomio.PolySubtract(p, s: TPolynomio): TPolynomio;
begin
  Result.Assign(p);
  for var i := 0 to High(p.value) do
    Result.value[i] := p.value[i] - s.value[i];
end;

function TPolynomio.ToString: string;
begin
  Result := '';
  var pd := Degree(self);
  for var i := pd downto 0 do
  begin
    var coeff := value[i];
    if coeff = 0.0 then
      Continue;
    if coeff = 1.0 then
    begin
      if i < pd then
        Result := Result + ' + ';
    end
    else
    begin
      if coeff = -1 then
      begin
        if i < pd then
          Result := Result + ' - '
        else
          Result := Result + '-';
      end
      else
      begin
        if coeff < 0.0 then
        begin
          if i < pd then
            Result := Result + format(' - %.1f', [-coeff])
          else
            Result := Result + format('%.1f', [coeff]);
        end
        else
        begin
          if i < pd then
            Result := Result + format(' + %.1f', [coeff])
          else
            Result := Result + format('%.1f', [coeff]);
        end;
      end;
    end;
    if i > 1 then
      Result := Result + 'x^' + i.tostring
    else if i = 1 then
      Result := Result + 'x';
  end;
end;

{ TPolySolution }

constructor TPolySolution.Create(q, r: TPolynomio);
begin
  Quotient.Assign(q);
  Remainder.Assign(r);
end;

// Just for force implicitty string conversion
procedure Writeln(s: string);
begin
  System.Writeln(s);
end;

var
  n, d: TPolynomio;
  Solution: PPolySolution;

begin
  n := [-42.0, 0.0, -12.0, 1.0];
  d := [-3.0, 1.0, 0.0, 0.0];

  Write('Numerator   : ');
  Writeln(n);
  Write('Denominator : ');
  Writeln(d);
  Writeln('-------------------------------------');
  Solution := n / d;
  Write('Quotient    : ');
  Writeln(Solution^.Quotient);
  Write('Remainder   : ');
  Writeln(Solution^.Remainder);
  FreeMem(Solution, sizeof(TPolySolution));
  Readln;
end.
