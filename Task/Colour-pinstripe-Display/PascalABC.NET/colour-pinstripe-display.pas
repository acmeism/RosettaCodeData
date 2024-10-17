##
uses GraphABC;

Window.title := 'Color Pinstripe';
var colors := |clblack, clred, clgreen, clblue, clmagenta, clcyan, clyellow, clwhite|;
var w := Window.Width;
var h := Window.Height div 4;
for var b := 1 to 4 do
begin
  var x := 0;
  var ci := 0;
  while (x < w) do
  begin
    var y := h * (b - 1);
    Brush.Color := colors[ci mod 8];
    FillRectangle(x, y, x + b, y + h);
    x += b;
    ci += 1;
  end;
end;
