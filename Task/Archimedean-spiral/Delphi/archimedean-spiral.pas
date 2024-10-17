procedure ArcSpiral(Image: TImage);
var Radius,Theta: double;
var X,Y: integer;
var Center: TPoint;
const Step = 0.2;
const Offset = 3; Spacing = 1.4;
begin
Image.Canvas.Brush.Color:=clWhite;
Image.Canvas.Rectangle(0,0,Image.Width,Image.Height);
Center:=Point(Image.Width div 2, Image.Height div 2);
Image.Canvas.MoveTo(Center.X,Center.Y);
Theta:=0;
while Theta<(40*Pi) do
	begin
	{Radius increases as theta increases}
	Radius:=Offset+Spacing*Theta;
	{Calculate position on circle}
	X:=Trunc(Radius*Cos(Theta)+Center.X);
	Y:=Trunc(Radius*sin(Theta)+Center.Y);
	Image.Canvas.LineTo(X,Y);
	Theta:=Theta+Step;
	end;
end;
