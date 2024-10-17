procedure DrawColorStripes(Image: TImage; Colors: array of TColor; PenWidth,Top,Bottom: integer);
{Draw vertical stripes across full width of image}
{Top/Bottom Control the position of the band of stripes}
{PenWidth controls width of the line drawn}
var X,X2,Y: integer;
begin
Image.Canvas.Pen.Width:=PenWidth;
for X:=0 to (Image.Width div PenWidth)-1 do
	begin
	Image.Canvas.Pen.Color:=Colors[X mod Length(Colors)];
	X2:=X * PenWidth;
	Image.Canvas.MoveTo(X2,Top);
	Image.Canvas.LineTo(X2,Bottom);
	end;
end;


var Colors: array [0..7] of TColor = (clBlack, clRed, clGreen, clBlue, clFuchsia, clAqua, clYellow, clWhite);

procedure ShowColorStripes(Image: TImage);
{Draw all four bands of stripes}
var SHeight: integer;
var I: integer;
begin
SHeight:=Image.Height div 4;
for I:=0 to 4-1 do
	begin
	DrawColorStripes(Image,Colors,I+1,SHeight*I,SHeight*(I+1));
	end;
end;
