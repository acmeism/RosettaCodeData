##
uses GraphABC;

Window.title := 'Color bars';
var colors := |clblack, clred, clgreen, clblue, clmagenta, clcyan, clyellow, clwhite|;
var w := Window.Width div colors.Count;
var h := Window.Height;
for var i := 0 to colors.Count - 1 do
begin
  Brush.Color := colors[i];
  FillRectangle(w * i, 0, w * i + w, h);
end;
