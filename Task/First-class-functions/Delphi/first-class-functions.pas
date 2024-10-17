program First_class_functions;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Math;

type
  TFunctionTuple = record
    forward, backward: TFunc<Double, Double>;
    procedure Assign(forward, backward: TFunc<Double, Double>);
  end;

  TFunctionTuples = array of TFunctionTuple;

var
  cube, croot, fsin, fcos, faSin, faCos: TFunc<Double, Double>;
  FunctionTuples: TFunctionTuples;
  ft: TFunctionTuple;

{ TFunctionTuple }

procedure TFunctionTuple.Assign(forward, backward: TFunc<Double, Double>);
begin
  self.forward := forward;
  self.backward := backward;
end;

begin
  cube :=
    function(x: Double): Double
    begin
      result := x * x * x;
    end;

  croot :=
    function(x: Double): Double
    begin
      result := Power(x, 1 / 3.0);
    end;

  fsin :=
    function(x: Double): Double
    begin
      result := Sin(x);
    end;

  fcos :=
    function(x: Double): Double
    begin
      result := Cos(x);
    end;

  faSin :=
    function(x: Double): Double
    begin
      result := ArcSin(x);
    end;

  faCos :=
    function(x: Double): Double
    begin
      result := ArcCos(x);
    end;

  SetLength(FunctionTuples, 3);
  FunctionTuples[0].Assign(fsin, faSin);
  FunctionTuples[1].Assign(fcos, faCos);
  FunctionTuples[2].Assign(cube, croot);

  for ft in FunctionTuples do
    Writeln(ft.backward(ft.forward(0.5)):2:2);

  readln;
end.
