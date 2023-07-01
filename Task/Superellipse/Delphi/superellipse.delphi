procedure DrawSuperElipse(Image: TImage);
var Points: array of double;
const N = 2.5;
const Border = 10;
var A: integer;
var X: integer;
var W2,H2: integer;
begin
{Make elipse size and position based on window size}
W2:=Image.Width div 2;
H2:=Image.Height div 2;
A:=Min(W2,H2)-Border;
{Fill array with points}
SetLength(Points,A);
for X:=0 to High(Points) do
 Points[X]:=Power(Power(A, N) - Power(X, N), 1 / N);

Image.Canvas.Pen.Color:=clRed;
Image.Canvas.Pen.Width:=2;

{Starting point}
Image.Canvas.MoveTo(W2+High(Points),trunc(H2-Points[High(Points)]));
{Draw Upper right}
for X:=High(Points) downto 0 do
	begin
	Image.Canvas.LineTo(W2+x, trunc(H2-Points[X]))
	end;
{Draw Upper left}
for X:=0 to High(Points) do
	begin
	Image.Canvas.LineTo(W2-X, trunc(H2-Points[X]))
	end;

{Draw Lower left}
for X:=High(Points) downto 0 do
	begin
	Image.Canvas.LineTo(W2-X, trunc(H2+Points[X]))
	end;
{Draw Lower right}
for X:=0 to High(Points) do
	begin
	Image.Canvas.LineTo(W2+X, trunc(H2+Points[X]))
	end;
{Connect back to beginning}
Image.Canvas.LineTo(W2+High(Points),trunc(H2-Points[High(Points)]));
Image.Repaint;
end;
