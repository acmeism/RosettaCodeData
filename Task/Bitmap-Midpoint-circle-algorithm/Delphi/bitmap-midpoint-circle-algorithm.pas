procedure DrawCircle(Image: TImage; Radius: integer; Center: TPoint);
var T1,T2: integer;
var X,Y: integer;
var Cnt: integer;

	procedure DrawPixels(X,Y: integer);
	{Draw pixel into all 8 octents}
	begin
	Image.Canvas.Pixels[Center.X + x, Center.Y + y]:=clRed;
	Image.Canvas.Pixels[Center.X - X, Center.Y + Y]:=clRed;
	Image.Canvas.Pixels[Center.X + X, Center.Y - Y]:=clRed;
	Image.Canvas.Pixels[Center.X - X, Center.Y - Y]:=clRed;
	Image.Canvas.Pixels[Center.X + Y, Center.Y + X]:=clRed;
	Image.Canvas.Pixels[Center.X - Y, Center.Y + X]:=clRed;
	Image.Canvas.Pixels[Center.X + y, Center.Y - X]:=clRed;
	Image.Canvas.Pixels[Center.X - Y, Center.Y - X]:=clRed;
	end;

begin
Cnt:=0;
T1:= Radius div 32;
{Start on X-axis}
X:= Radius; Y:= 0;
repeat
	begin
	DrawPixels(X, Y);
	Y:=Y + 1;
	T1:=T1 + Y;
	T2:=T1 - X;
	if T2 >= 0 then
		begin
		T1:=T2;
		X:=X - 1;
		end;
	Inc(Cnt);
	end
until x < y;
Form1.Caption:=IntToStr(Cnt);
end;



procedure ShowBrezCircle(Image: TImage);
begin
{Draw three times to make line thicker}
DrawCircle(Image,100,Point(200,200));
DrawCircle(Image,99,Point(200,200));
DrawCircle(Image,98,Point(200,200));
Image.Invalidate;
end;
