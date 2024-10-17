procedure MunchingSquares(Image: TImage);
{XOR's X and Y to select an RGB level}
var W,H,X,Y: integer;
begin
W:=Image.Width;
H:=Image.Height;
for Y:=0 to Image.Height-1 do
 for X:=0 to Image.Width-1 do
	begin
	Image.Canvas.Pixels[X,Y]:=RGB(0,X xor Y,0);
	end;
end;
