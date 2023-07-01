program Julia_set;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Winapi.Windows,
  Vcl.Graphics;

var
  Colors: array[0..255] of TColor;
  w, h, zoom, maxiter, moveX, moveY: Integer;
  cX, cY, zx, zy, tmp: Double;
  i: Integer;
  bitmap: TBitmap;
  x, y: Integer;

begin
  w := 800;
  h := 600;
  zoom := 1;
  maxiter := 255;
  moveX := 0;
  moveY := 0;
  cX := -0.7;
  cY := 0.27015;
  bitmap := TBitmap.Create();
  bitmap.SetSize(w, h);
  bitmap.Canvas.Brush.Color := clwhite;
  bitmap.Canvas.FillRect(bitmap.Canvas.ClipRect);

  for i := 0 to 255 do
    Colors[i] := RGB((i shr 5) * 36, ((i shr 3) and 7) * 36, (i and 3) * 85);

  for x := 0 to w - 1 do
  begin
    for y := 0 to h - 1 do
    begin
      zx := 1.5 * (x - w / 2) / (0.5 * zoom * w) + moveX;
      zy := 1.0 * (y - h / 2) / (0.5 * zoom * h) + moveY;
      i := maxiter;
      while (zx * zx + zy * zy < 4) and (i > 1) do
      begin
        tmp := zx * zx - zy * zy + cX;
        zy := 2.0 * zx * zy + cY;
        zx := tmp;
        i := i - 1;
      end;
      bitmap.Canvas.Pixels[x, y] := colors[i];
    end;
  end;

  bitmap.SaveToFile('julia-set.bmp');
  bitmap.Free;
end.
