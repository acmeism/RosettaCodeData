procedure ShowBitmapFunctions(Image: TImage);
{Code to demonstrate some of the main features the Delphi "TCanvas" object}
var I,X,Y: integer;
var C: TColor;
begin
{Draw red rectangle with 3 pixels wide lines}
Image.Canvas.Pen.Color:=clRed;
Image.Canvas.Pen.Width:=3;
Image.Canvas.Rectangle(50,50,500,300);
{Flood fill rectangle blue}
Image.Canvas.Brush.Color:=clBlue;
Image.Canvas.FloodFill(55,55,clRed,fsBorder);
{Draw random dots on the screen}
for I:=1 to 1000 do
	begin
	X:=trunc((Random * 450) + 50);
	Y:=trunc((Random * 250) + 50);
	C:=RGB(Random(255),Random(255),Random(255));
	{draw 9 pixels for each point to make dots more visible}
	Image.Canvas.Pixels[X-1,Y-1]:=C;
	Image.Canvas.Pixels[X  ,Y-1]:=C;
	Image.Canvas.Pixels[X+1,Y-1]:=C;
	Image.Canvas.Pixels[X-1,Y  ]:=C;
	Image.Canvas.Pixels[X  ,Y  ]:=C;
	Image.Canvas.Pixels[X+1,Y  ]:=C;
	Image.Canvas.Pixels[X-1,Y+1]:=C;
	Image.Canvas.Pixels[X  ,Y+1]:=C;
	Image.Canvas.Pixels[X+1,Y+1]:=C;
	end;
{Draw lime-green line from corner to cornder}
Image.Canvas.Pen.Color:=clLime;
Image.Canvas.MoveTo(50,50);
Image.Canvas.LineTo(500,300);
{Sample pixel color at 51,51}
C:=Image.Canvas.Pixels[51,51];
{Display the color value }
Image.Canvas.Brush.Color:=clAqua;
Image.Canvas.Font.Size:=25;
Image.Canvas.Font.Color:=clRed;
Image.Canvas.TextOut(5,5,IntToHex(C,8));
{Tell Delphi to update the Window}
Image.Repaint;
end;
