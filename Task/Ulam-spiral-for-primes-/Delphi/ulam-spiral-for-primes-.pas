procedure DrawMatrixPrimes(Image: TImage; Mat: TMatrix);
{Display spiral, only marking cells that contain prime numbers}
var X,Y: integer;
var S: string;
var Size,Step: integer;
var Off: TSize;
var R: TRect;
begin
{Calculate size of grid}
Size:=Min(Image.Width,Image.Height);
Step:=Size div Length(Mat);
{Draw border rectangle}
Image.Canvas.Brush.Color:=clGreen;
Image.Canvas.Pen.Width:=4;
Image.Canvas.Rectangle(2,2,Length(Mat)*Step,Length(Mat)*Step);
{Setup font}
Image.Canvas.Font.Name:='Arial';
Image.Canvas.Font.Style:=[fsBold];
Image.Canvas.Font.Size:=14;
{Draw grid}
Image.Canvas.Pen.Width:=1;
{Draw vertical lines}
for X:=0 to Length(Mat) do
	begin
	Image.Canvas.MoveTo(X*Step,0);
	Image.Canvas.LineTo(X*Step,Step*Length(Mat));
	end;
{Draw horizontal lines}
for Y:=0 to Length(Mat) do
	begin
	Image.Canvas.MoveTo(0,Y*Step);
	Image.Canvas.LineTo(Step*Length(Mat),Y*Step);
	end;
{Label cells that contain primes}
for Y:=0 to High(Mat[0]) do
 for X:=0 to High(Mat) do
  if IsPrime(trunc(Mat[X,Y])) then
	begin
	{Color cells}
	R:=Rect((X*Step)+2,(Y*Step)+2,X*Step+Step,Y*Step+Step);
	InflateRect(R,-1,-1);
	Image.Canvas.Pen.Width:=4;
	Image.Canvas.Pen.Color:=clBlue;
	Image.Canvas.Brush.Color:=clLime;
	Image.Canvas.Rectangle(R);
	{Label cell}
	S:=Format('%0.0f',[Mat[X,Y]]);
	Off:=Image.Canvas.TextExtent(S);
	Off.CX:=(Step-Off.CX) div 2;
	Off.CY:=(Step-Off.CY) div 2;
	Image.Canvas.TextOut(X*Step+Off.CX,Y*Step+Off.CY,S);
	end;
Image.Invalidate;
end;



procedure MakeSqrSpiralMatrix(var Mat: TMatrix; MatSize: integer);
{Create a spiral matrix of specified size}
var Inx: integer;
var R: TRect;



	procedure DoTopRect(Off1,Off2: integer);
	{Do top part of rectangle}
	var X,Y: integer;
	begin
	for X:=R.Left+Off1 to R.Right+Off2 do
		begin
		Mat[X,R.Top]:=Inx;
		Dec(Inx);
		end;
	end;

	procedure DoRightRect(Off1,Off2: integer);
	{Do Right part of rectangle}
	var X,Y: integer;
	begin
	for Y:=R.Top+Off1 to R.Bottom+Off2 do
		begin
		Mat[R.Right,Y]:=Inx;
		Dec(Inx);
		end;
	end;


	procedure DoBottomRect(Off1,Off2: integer);
	{Do bottom part of rectangle}
	var X,Y: integer;
	begin
	for X:= R.Right+Off1 downto R.Left+Off2 do
		begin
		Mat[X,R.Bottom]:=Inx;
		Dec(Inx);
		end;
	end;

	procedure DoLeftRect(Off1,Off2: integer);
	{Do left part of rectangle}
	var X,Y: integer;
	begin
	for Y:=R.Bottom+Off1 downto R.Top+Off2 do
		begin
		Mat[R.Left,Y]:=Inx;
		Dec(Inx);
		end;
	end;


	procedure DoRect(R: TRect; var Inx: integer);
	{Create one rotation of spiral around the rectangle}
	begin
	{The orientation of spiral is based in the size}
	if (MatSize and 1)=0 then
		begin
		{Handle even sizes}
		DoTopRect(0,0);
		DoRightRect(1,0);
		DoBottomRect(-1,0);
		DoLeftRect(-1,1);
		end
	else
		begin
		{Handle odd sizes}
		DoBottomRect(0,0);
		DoLeftRect(-1,0);
		DoTopRect(1,0);
		DoRightRect(1,-1);
		end
	end;



begin
{Set matrix size}
SetLength(Mat,MatSize,MatSize);
{create matching rectangle}
R:=Rect(0,0,MatSize-1,MatSize-1);
Inx:=MatSize*MatSize;
{draw spiral around retangle and deflate rectanle until spiral is done}
while (R.Left<=R.Right) and (R.Top<=R.Bottom) do
	begin
	DoRect(R,Inx);
	InflateRect(R,-1,-1);
	end;
end;



procedure UlamPrimeSpiral(Image: TImage);
var Mat: TMatrix;
begin
MakeSqrSpiralMatrix(Mat,9);
DrawMatrixPrimes(Image,Mat);
end;
