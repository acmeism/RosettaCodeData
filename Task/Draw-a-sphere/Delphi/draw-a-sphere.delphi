program DrawASphere;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Math;

type
  TDouble3  = array[0..2] of Double;
  TChar10 = array[0..9] of Char;

var
  shades: TChar10 = ('.', ':', '!', '*', 'o', 'e', '&', '#', '%', '@');
  light: TDouble3 = (30, 30, -50 );

  procedure normalize(var v: TDouble3);
  var
    len: Double;
  begin
    len:= sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);
    v[0] := v[0] / len;
    v[1] := v[1] / len;
    v[2] := v[2] / len;
  end;

  function dot(x, y: TDouble3): Double;
  begin
    Result:= x[0]*y[0] + x[1]*y[1] + x[2]*y[2];
    Result:= IfThen(Result < 0, -Result, 0 );
  end;

  procedure drawSphere(R, k, ambient: Double);
  var
    vec: TDouble3;
    x, y, b: Double;
    i, j,
    intensity: Integer;
  begin
    for i:= Floor(-R) to Ceil(R) do
    begin
      x := i + 0.5;
      for j:= Floor(-2*R) to Ceil(2 * R) do
      begin
        y:= j / 2 + 0.5;
        if(x * x + y * y <= R * R) then
        begin
          vec[0]:= x;
          vec[1]:= y;
          vec[2]:= sqrt(R * R - x * x - y * y);
          normalize(vec);
          b:= Power(dot(light, vec), k) + ambient;
          intensity:= IfThen(b <= 0,
                             Length(shades) - 2,
                             Trunc(max( (1 - b) * (Length(shades) - 1), 0 )));
          Write(shades[intensity]);
        end
        else
          Write(' ');
      end;
      Writeln;
    end;
  end;

begin
  normalize(light);
  drawSphere(19, 4, 0.1);
  drawSphere(10, 2, 0.4);
  Readln;
end.
