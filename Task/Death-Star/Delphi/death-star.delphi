program Death_Star;

{$APPTYPE CONSOLE}

uses
  Winapi.Windows,
  System.SysUtils,
  system.Math,
  Vcl.Graphics,
  Vcl.Imaging.pngimage;

type
  TVector = array of double;

var
  light: TVector = [20, -40, -10];

function ClampInt(value, amin, amax: Integer): Integer;
begin
  Result := Max(amin, Min(amax, value))
end;

procedure Normalize(var v: TVector);
begin
  var len := Sqrt(v[0] * v[0] + v[1] * v[1] + v[2] * v[2]);
  v[0] := v[0] / len;
  v[1] := v[1] / len;
  v[2] := v[2] / len;
end;

function Dot(x, y: TVector): Double;
begin
  var d := x[0] * y[0] + x[1] * y[1] + x[2] * y[2];
  if d < 0 then
    Result := -d
  else
    Result := 0;
end;

type
  TSphere = record
    cx, cy, cz, r: Double;
  end;

const
  pos: TSphere = (
    cx: 0;
    cy: 0;
    cz: 0;
    r: 120
  );

const
  neg: TSphere = (
    cx: -90;
    cy: -90;
    cz: -30;
    r: 80
  );

function HitSphere(sph: TSphere; x, y: double; var z1, z2: Double): Boolean;
begin
  x := x - sph.cx;
  y := y - sph.cy;
  var zsq := sph.r * sph.r - (x * x + y * y);
  if (zsq < 0) then
    Exit(False);
  zsq := Sqrt(zsq);
  z1 := sph.cz - zsq;
  z2 := sph.cz + zsq;
  Result := True;
end;

function DeathStar(pos, neg: TSphere; k, amb: Double; light: TVector): TBitmap;
var
  w, h, yMax, xMax, s: double;
  zp1, zp2, zn1, zn2, b: Double;
  x, y: Integer;
  hit: Boolean;
  vec: TVector;
  intensity: Byte;
  ox, oy: Integer;
begin
  w := pos.r * 4;
  h := pos.r * 3;
  ox := -trunc(pos.cx - w / 2);
  oy := -trunc(pos.cy - h / 2);

  vec := [0, 0, 0];
  Result := TBitmap.Create;
  Result.SetSize(trunc(w), trunc(h));

  yMax := pos.cy + pos.r;
  for y := Trunc(pos.cy - pos.r) to Trunc(yMax) do
  begin
    xMax := pos.cx + pos.r;
    for x := trunc(pos.cy - pos.r) to trunc(xMax) do
    begin
      hit := HitSphere(pos, x, y, zp1, zp2);
      if not hit then
        continue;

      hit := HitSphere(neg, x, y, zn1, zn2);

      if hit then
      begin
        if zn1 > zp1 then
          hit := false
        else if zn2 > zp2 then
          continue;
      end;

      if hit then
      begin
        vec[0] := neg.cx - x;
        vec[1] := neg.cy - y;
        vec[2] := neg.cz - zn2;
      end
      else
      begin
        vec[0] := x - pos.cx;
        vec[1] := y - pos.cy;
        vec[2] := zp1 - pos.cz;
      end;

      Normalize(vec);

      s := max(0, dot(light, vec));

      b := Power(s, k) + amb;

      intensity := ClampInt(round(255 * b / (1 + amb)), 0, 254);

      Result.Canvas.Pixels[x + ox, y + oy] := rgb(intensity, intensity, intensity);
    end;
  end;
end;

var
  bmp: TBitmap;

begin
  Normalize(light);
  bmp := DeathStar(pos, neg, 1.2, 0.3, light);

  with TPngImage.Create do
  begin
    Assign(bmp);
    TransparentColor := clwhite;
    SaveToFile('out.png');
    bmp.Free;
    Free;
  end;
end.
