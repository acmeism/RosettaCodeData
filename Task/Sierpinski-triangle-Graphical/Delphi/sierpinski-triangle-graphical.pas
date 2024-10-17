const DepthColors24: array [0..23] of TColor =(
	  0 or   (0 shl 8) or   (0 shl 16),
	255 or   (0 shl 8) or   (0 shl 16),
	255 or  (63 shl 8) or   (0 shl 16),
	255 or (127 shl 8) or   (0 shl 16),
	255 or (191 shl 8) or   (0 shl 16),
	255 or (255 shl 8) or   (0 shl 16),
	191 or (255 shl 8) or   (0 shl 16),
	127 or (255 shl 8) or   (0 shl 16),
	 63 or (255 shl 8) or   (0 shl 16),
	  0 or (255 shl 8) or   (0 shl 16),
	  0 or (255 shl 8) or  (63 shl 16),
	  0 or (255 shl 8) or (127 shl 16),
	  0 or (255 shl 8) or (191 shl 16),
	  0 or (255 shl 8) or (255 shl 16),
	  0 or (191 shl 8) or (255 shl 16),
	  0 or (127 shl 8) or (255 shl 16),
	  0 or  (63 shl 8) or (255 shl 16),
	  0 or   (0 shl 8) or (255 shl 16),
	 63 or   (0 shl 8) or (255 shl 16),
	127 or   (0 shl 8) or (255 shl 16),
	191 or   (0 shl 8) or (255 shl 16),
	255 or   (0 shl 8) or (255 shl 16),
	255 or   (0 shl 8) or (191 shl 16),
	255 or   (0 shl 8) or (127 shl 16));

procedure DrawSerpTriangle(Image: TImage; StartX,StartY, Depth: integer);
var I,X,Y,Size,Inx: integer;
var C: TColor;
begin
Size:=1 shl Depth;
for Y:=0 to Size-1 do
 for X:=0 to Size-1 do
	begin
	{Calculate new color index}
	Inx:=MulDiv(Length(DepthColors24),X+Y,Size+Size)+1;
	if (X and Y)=0 then
		begin
		Image.Canvas.Pixels[StartX+X,StartY+Y]:=DepthColors24[Inx];
		end;
	end;
end;

procedure ShowSierpinskiTriangle(Image: TImage);
begin
ClearImage(Image,clBlack);
DrawSerpTriangle(Image,50,32,8);
Image.Invalidate;
end;
