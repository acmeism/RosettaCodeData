uses GraphABC, system;

function fmod(x, y: real): real := x - trunc(x / y) * y;

function HSVToRGB(h, s, v: real): Color;
begin
  var hp := h / 60.0;
  var c := s * v;
  var x := c * (1 - abs(fmod(hp, 2) - 1));
  var m := v - c;
  var (r, g, b) := (0.0, 0.0, 0.0);
  if (hp <= 1) then (r, g) := (c, x)
  else if (hp <= 2) then (r, g) := (x, c)
  else if (hp <= 3) then (g, b) := (c, x)
  else if (hp <= 4) then (g, b) := (x, c)
  else if (hp <= 5) then (r, b) := (x, c)
  else (r, b) := (c, x);
  r += m;
  g += m;
  b += m;
  result := RGB(byte(r * 255), byte(g * 255), byte(b * 255));
end;

procedure ColorWheel(diameter: integer);
begin
  Window.Title := 'ColorWheel';
  SetWindowSize(diameter, diameter);
  var radius := diameter / 2;

  for var x := 0 to diameter do
  begin
    var rx := x - radius;
    for var y := 0 to diameter do
    begin
      var ry := y - radius;
      var r := (rx.Sqr + ry.Sqr).Sqrt / radius;
      if r > 1 then continue;
      var a := 180 + RadToDeg(math.Atan2(ry, -rx));
      SetPixel(x, y, HSVToRGB(a, r, 1));
    end;
  end;
end;

begin
  ColorWheel(300);
end.
