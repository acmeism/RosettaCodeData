procedure DrawVerticalStripes(Image: TImage; PenWidth,Top,Bottom: integer);
{Draw vertical stripes across full width of image}
{Top/Bottom Control the position of the band of stripes}
{PenWidth controls width of the line drawn}
var X,X2,Y: integer;
begin
Image.Canvas.Pen.Width:=PenWidth;
for X:=0 to (Image.Width div PenWidth)-1 do
	begin
	if (X mod 2)=0 then Image.Canvas.Pen.Color:=clWhite
	else Image.Canvas.Pen.Color:=clBlack;
	X2:=X * PenWidth;
	Image.Canvas.MoveTo(X2,Top);
	Image.Canvas.LineTo(X2,Bottom);
	end;
end;

procedure ShowVerticalStripes(Image: TImage);
{Draw all four bands of stripes}
var SHeight: integer;
var I: integer;
begin
SHeight:=Image.Height div 4;
for I:=0 to 4-1 do
	begin
	DrawVerticalStripes(Image,I+1,SHeight*I,SHeight*(I+1));
	end;
end;
