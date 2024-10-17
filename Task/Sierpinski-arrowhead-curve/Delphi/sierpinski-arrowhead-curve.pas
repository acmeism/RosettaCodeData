type T2DVector=packed record
  X,Y: double;
  end;

var Pos: T2DVector;
var CurAngle: double;


procedure Turn(Angle: double);
{Turn current angle by specified degrees}
begin
CurAngle:=CurAngle+Angle;
end;


procedure DrawLine(Canvas: TCanvas; Len: double);
{Draw current line, rotated by the current angle}
var P2: T2DVector;
begin
Canvas.Pen.Mode:=pmCopy;
Canvas.Pen.Style:=psSolid;
P2.X:= Pos.X + Len*Cos(DegToRad(CurAngle));
P2.Y:= Pos.Y - Len*Sin(DegToRad(CurAngle));
Canvas.MoveTo(Round(Pos.X),Round(Pos.Y));
Canvas.LineTo(Round(P2.X),Round(P2.Y));
Pos:=P2;
end;

procedure Curve(Canvas: TCanvas; Order: integer; Length: double; Angle: integer);
{Recursively draw curve of specified order and based specified Angle}
begin
if 0 = Order then DrawLine(Canvas,Length)
else
	begin
	Curve(Canvas,Order - 1, Length / 2, -Angle);
	Turn(angle);
	curve(Canvas,Order - 1, Length / 2, Angle);
	Turn(angle);
	Curve(Canvas,Order - 1, Length / 2, -Angle);
	end;
end;


procedure SierpinskiArrowheadCurve(Image: TImage; Order: integer; Length: double);
{Draw arrowhead curve of specified order.}
{Length controls the width of one side of the arrowhead }
begin
Pos.X:=10; Pos.Y:=10;
if (Order and 1)=0 then Curve(Image.Canvas, Order, Length, +60)
else
	begin
	{Order is odd}
	Turn(+60);
	Curve(Image.Canvas, Order, Length, -60);
	end;
end;


procedure ShowSierpinskiArrowhead(Image: TImage);
var Size: double;
begin
if Image.Width>Image.Height then Size:=Image.Height/0.9
else Size:=Image.Width;
{Super impose three different orders, colors and line-widths}
Image.Canvas.Pen.Color:=clBlack;
Image.Canvas.Pen.Width:=3;
SierpinskiArrowheadCurve(Image,4, Size);
Image.Canvas.Pen.Color:=clBlue;
Image.Canvas.Pen.Width:=2;
SierpinskiArrowheadCurve(Image,6, Size);
Image.Canvas.Pen.Color:=clRed;
Image.Canvas.Pen.Width:=1;
SierpinskiArrowheadCurve(Image,8, Size);
end;
