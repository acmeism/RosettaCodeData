program Numerical_integration;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  TFx = TFunc<Double, Double>;

  TMethod = TFunc<TFx, Double, Double, Double>;

function RectLeft(f: TFx; x, h: Double): Double;
begin
  RectLeft := f(x);
end;

function RectMid(f: TFx; x, h: Double): Double;
begin
  RectMid := f(x + h / 2);
end;

function RectRight(f: TFx; x, h: Double): Double;
begin
  Result := f(x + h);
end;

function Trapezium(f: TFx; x, h: Double): Double;
begin
  Result := (f(x) + f(x + h)) / 2.0;
end;

function Simpson(f: TFx; x, h: Double): Double;
begin
  Result := (f(x) + 4 * f(x + h / 2) + f(x + h)) / 6.0;
end;

function Integrate(Method: TMethod; f: TFx; a, b: Double; n: Integer): Double;
var
  h: Double;
  k: integer;
begin
  Result := 0;
  h := (b - a) / n;
  for k := 0 to n - 1 do
    Result := Result + Method(f, a + k * h, h);
  Result := Result * h;
end;

function f1(x: Double): Double;
begin
  Result := x * x * x;
end;

function f2(x: Double): Double;
begin
  Result := 1 / x;
end;

function f3(x: Double): Double;
begin
  Result := x;
end;

var
  fs: array[0..3] of TFx;
  mt: array[0..4] of TMethod;
  fsNames: array of string = ['x^3', '1/x', 'x', 'x'];
  mtNames: array of string = ['RectLeft', 'RectMid', 'RectRight', 'Trapezium', 'Simpson'];
  limits: array of array of Double = [[0, 1, 100], [1, 100, 1000], [0, 5000,
    5000000], [0, 6000, 6000000]];
  i, j, n: integer;
  a, b: double;

begin
  fs[0] := f1;
  fs[1] := f2;
  fs[2] := f3;
  fs[3] := f3;

  mt[0] := RectLeft;
  mt[1] := RectMid;
  mt[2] := RectRight;
  mt[3] := Trapezium;
  mt[4] := Simpson;

  for i := 0 to High(fs) do
  begin
    Writeln('Integrate ' + fsNames[i]);
    a := limits[i][0];
    b := limits[i][1];
    n := Trunc(limits[i][2]);

    for j := 0 to High(mt) do
      Writeln(Format('%.6f', [Integrate(mt[j], fs[i], a, b, n)]));
  end;
  readln;
end.
