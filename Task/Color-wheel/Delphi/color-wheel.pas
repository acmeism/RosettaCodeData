program Color_wheel;

{$APPTYPE CONSOLE}

uses
  Winapi.Windows,
  System.SysUtils,
  Vcl.Graphics,
  System.Math,
  Vcl.Imaging.pngimage;

const
  TAU = 2 * PI;

function HSBtoColor(hue, sat, bri: Double): TColor;
var
  f, h: Double;
  u, p, q, t: Byte;
begin
  u := Trunc(bri * 255 + 0.5);
  if sat = 0 then
    Exit(rgb(u, u, u));

  h := (hue - Floor(hue)) * 6;
  f := h - Floor(h);
  p := Trunc(bri * (1 - sat) * 255 + 0.5);
  q := Trunc(bri * (1 - sat * f) * 255 + 0.5);
  t := Trunc(bri * (1 - sat * (1 - f)) * 255 + 0.5);

  case Trunc(h) of
    0:
      result := rgb(u, t, p);
    1:
      result := rgb(q, u, p);
    2:
      result := rgb(p, u, t);
    3:
      result := rgb(p, q, u);
    4:
      result := rgb(t, p, u);
    5:
      result := rgb(u, p, q);
  else
    result := clwhite;
  end;

end;

function ColorWheel(Width, Height: Integer): TPngImage;
var
  Center: TPoint;
  Radius: Integer;
  x, y: Integer;
  Hue, dy, dx, dist, theta: Double;
  Bmp: TBitmap;
begin
  Bmp := TBitmap.Create;
  Bmp.SetSize(Width, Height);
  with Bmp.Canvas do
  begin
    Brush.Color := clWhite;
    FillRect(ClipRect);
    Center := ClipRect.CenterPoint;
    Radius := Center.X;
    if Center.Y < Radius then
      Radius := Center.Y;
    for y := 0 to Height - 1 do
    begin
      dy := y - Center.y;
      for x := 0 to Width - 1 do
      begin
        dx := x - Center.x;
        dist := Sqrt(Sqr(dx) + Sqr(dy));
        if dist <= Radius then
        begin
          theta := ArcTan2(dy, dx);
          Hue := (theta + PI) / TAU;
          Pixels[x, y] := HSBtoColor(Hue, 1, 1);
        end;
      end;
    end;
  end;

  Result := TPngImage.Create;
  Result.Assign(Bmp);
  Bmp.Free;
end;

begin
  with ColorWheel(500, 500) do
  begin
    SaveToFile('ColorWheel.png');
    Free;
  end;
end.
