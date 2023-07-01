procedure DrawCircle(Canvas: TCanvas; Center: TPoint; Radius: integer);
{Draw circle at specified center and size (Radius)}
var R: TRect;
begin
R.TopLeft:=Center;
R.BottomRight:=Center;
InflateRect(R,Radius,Radius);
Canvas.Ellipse(R);
end;

procedure DrawYinYang(Canvas: TCanvas; Center: TPoint; Radius: integer);
{Draw Yin-Yang symbol at specified center and size (Radius)}
var X1,Y1,X2,Y2,X3,Y3,X4,Y4: integer;
var R2,R6: integer;
begin
R2:=Radius div 2;
R6:=Radius div 6;
Canvas.Pen.Width:=3;

{Draw outer circle}
DrawCircle(Canvas,Center,Radius);

{Draw bottom half circle}
X1:=Center.X - R2; Y1:=Center.Y;
X2:=Center.X + R2; Y2:=Center.Y + Radius;
X3:=Center.X; Y3:=Center.Y;
X4:=Center.X; Y4:=Center.Y + Radius;
Canvas.Arc(X1,Y1, X2,Y2, X3,Y3, X4, Y4);

{Draw top half circle}
X1:=Center.X - R2; Y1:=Center.Y;
X2:=Center.X + R2; Y2:=Center.Y - Radius;
X3:=Center.X; Y3:=Center.Y;
X4:=Center.X; Y4:=Center.Y- Radius;
Canvas.Arc(X1,Y1, X2,Y2, X3,Y3, X4, Y4);

{Fill right half with black}
Canvas.Brush.Color:=clBlack;
Canvas.FloodFill(Center.X,Center.Y+5,clWhite, fsSurface);

{Draw top small circle}
DrawCircle(Canvas, Point(Center.X, Center.Y-R2), R6);

{Draw bottom small circle}
Canvas.Brush.Color:=clWhite;
DrawCircle(Canvas, Point(Center.X, Center.Y+R2), R6);
end;


procedure ShowYinYang(Image: TImage);
begin
DrawYinYang(Image.Canvas,Point(75,75),50);
DrawYinYang(Image.Canvas,Point(200,200),100);
Image.Invalidate;
end;
