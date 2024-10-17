procedure DrawTree(Image: TImage; X1, Y1: integer; Angle: double; Depth: integer);
var X2,Y2: integer;
begin
if Depth = 0 then exit;
X2:=trunc(X1 + cos(DegToRad(Angle)) * Depth * 5);
Y2:=trunc(Y1 + sin(DegToRad(Angle)) * Depth * 5);
Image.Canvas.Pen.Color:=ColorMap47[MulDiv(High(ColorMap47),Depth,11)];
Image.Canvas.Pen.Width:=MulDiv(Depth,5,10);
Image.Canvas.MoveTo(X1,Y1);
Image.Canvas.LineTo(X2,Y2);
DrawTree(Image, X2, Y2, Angle - 10, Depth - 1);
DrawTree(Image, X2, Y2, Angle + 35, Depth - 1);
end;


procedure ShowFactalTree(Image: TImage);
begin
ClearImage(Image,clBlack);
DrawTree(Image, 250, 350, -90, 11);
Image.Invalidate;
end;
