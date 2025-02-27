uses GraphWPF;

const
  W = 800;
  H = 600;
  Zoom = 1;
  MaxIter = 255;
  MoveX = 0;
  MoveY = 0;
  Cx = -0.7;
  Cy = 0.27015;

begin
  var colors: array [0..255] of color;
  for var n := 0 to 255 do
    colors[n] := RGB(n shr 5 * 36, (n shr 3 and 7) * 36, (n and 3) * 85);

  Window.Title := 'Julia set';
  var image := new Color[W, H];

  for var x := 0 to W - 1 do
    for var y := 0 to H - 1 do
    begin
      var zx := 1.5 * (x - W / 2) / (0.5 * Zoom * W) + MoveX;
      var zy := 1.0 * (y - H / 2) / (0.5 * Zoom * H) + MoveY;
      var i := MaxIter;
      while (zx * zx + zy * zy < 4) and (i > 1) do
      begin
        (zy, zx) := (2.0 * zx * zy + Cy, zx * zx - zy * zy + Cx);
        i -= 1;
      end;
      image[x, y] := colors[i];
    end;
  DrawPixels(0,0,image);
end.
