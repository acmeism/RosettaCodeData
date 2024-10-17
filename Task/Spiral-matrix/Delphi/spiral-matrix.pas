type TMatrix = array of array of double;


procedure DisplayMatrix(Memo: TMemo; Mat: TMatrix);
{Display specified matrix}
var X,Y: integer;
var S: string;
begin
S:='';
for Y:=0 to High(Mat[0]) do
	begin
	S:=S+'[';
	for X:=0 to High(Mat) do
	  S:=S+Format('%4.0f',[Mat[X,Y]]);
	S:=S+']'+#$0D#$0A;
	end;
Memo.Lines.Add(S);
end;


procedure MakeSpiralMatrix(var Mat: TMatrix; SizeX,SizeY: integer);
{Create a spiral matrix of specified size}
var Inx: integer;
var R: TRect;

	procedure DoRect(R: TRect; var Inx: integer);
	{Create on turn of the spiral base on the rectangle}
	var X,Y: integer;
	begin
	{Do top part of rectangle}
	for X:=R.Left to R.Right do
		begin
		Mat[X,R.Top]:=Inx;
		Inc(Inx);
		end;
	{Do Right part of rectangle}
	for Y:=R.Top+1 to R.Bottom do
		begin
		Mat[R.Right,Y]:=Inx;
		Inc(Inx);
		end;
	{Do bottom part of rectangle}
	for X:= R.Right-1 downto R.Left do
		begin
		Mat[X,R.Bottom]:=Inx;
		Inc(Inx);
		end;
	{Do left part of rectangle}
	for Y:=R.Bottom-1 downto R.Top+1 do
		begin
		Mat[R.Left,Y]:=Inx;
		Inc(Inx);
		end;
	end;

begin
{Set matrix size}
SetLength(Mat,SizeX,SizeY);
{create matching rectangle}
R:=Rect(0,0,SizeX-1,SizeY-1);
Inx:=0;
{draw and deflate rectangle until spiral is done}
while (R.Left<=R.Right) and (R.Top<=R.Bottom) do
	begin
	DoRect(R,Inx);
	InflateRect(R,-1,-1);
	end;
end;



procedure SpiralMatrix(Memo: TMemo);
{Display spiral matrix}
var Mat: TMatrix;
begin
Memo.Lines.Add('5x5 Matrix');
MakeSpiralMatrix(Mat,5,5);
DisplayMatrix(Memo,Mat);

Memo.Lines.Add('8x8 Matrix');
MakeSpiralMatrix(Mat,8,8);
DisplayMatrix(Memo,Mat);

Memo.Lines.Add('14x8 Matrix');
MakeSpiralMatrix(Mat,14,8);
DisplayMatrix(Memo,Mat);
end;
